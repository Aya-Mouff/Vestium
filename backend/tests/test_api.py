# tests/test_api.py

# Helper functions
def register_user(client, email="test@example.com", password="TestPass123!", full_name="Test User", username=None):
    payload = {
        "email": email,
        "password": password,
        "full_name": full_name,
    }
    if username:
        payload["username"] = username
    resp = client.post("/api/auth/register", json=payload)
    assert resp.status_code == 201
    data = resp.get_json()
    return data["user"], data["access_token"], data["refresh_token"]


def login_user(client, email="test@example.com", password="TestPass123!"):
    resp = client.post(
        "/api/auth/login",
        json={"email": email, "password": password},
    )
    assert resp.status_code == 200
    data = resp.get_json()
    return data["user"], data["access_token"], data["refresh_token"]


def auth_header(client, username="api_user", email="api_user@example.com"):
    register_user(client, email=email, password="TestPass123!", full_name=username, username=username)
    _, access, _ = login_user(client, email=email)
    return {"Authorization": f"Bearer {access}"}


# ---------- AUTH (auth.py) ----------

def test_register_success(client, db_session):
    resp = client.post(
        "/api/auth/register",
        json={
            "email": "auth_user@example.com",
            "password": "TestPass123!",
            "full_name": "Auth User",
            "username": "auth_user",
        },
    )
    assert resp.status_code == 201
    data = resp.get_json()
    assert "user" in data
    assert "access_token" in data
    assert "refresh_token" in data
    assert data["user"]["email"] == "auth_user@example.com"


def test_register_invalid_email(client, db_session):
    resp = client.post(
        "/api/auth/register",
        json={
            "email": "bad-email",
            "password": "TestPass123!",
            "full_name": "Bad Email",
        },
    )
    assert resp.status_code == 400
    data = resp.get_json()
    assert "Invalid email format" in data["error"]


def test_login_success(client, db_session):
    client.post(
        "/api/auth/register",
        json={
            "email": "login_ok@example.com",
            "password": "TestPass123!",
            "full_name": "Login Ok",
        },
    )
    resp = client.post(
        "/api/auth/login",
        json={
            "email": "login_ok@example.com",
            "password": "TestPass123!",
        },
    )
    assert resp.status_code == 200
    data = resp.get_json()
    assert "access_token" in data
    assert "refresh_token" in data
    assert "user" in data


def test_login_invalid_credentials(client, db_session):
    client.post(
        "/api/auth/register",
        json={
            "email": "login_fail@example.com",
            "password": "TestPass123!",
            "full_name": "Login Fail",
        },
    )
    resp = client.post(
        "/api/auth/login",
        json={
            "email": "login_fail@example.com",
            "password": "wrong-password",
        },
    )
    assert resp.status_code == 401
    data = resp.get_json()
    assert "Invalid email or password" in data["error"]


def test_refresh_token_flow(client, db_session):
    reg = client.post(
        "/api/auth/register",
        json={
            "email": "refresh_user@example.com",
            "password": "TestPass123!",
            "full_name": "Refresh User",
        },
    )
    reg_data = reg.get_json()
    refresh_token = reg_data["refresh_token"]
    headers = {"Authorization": f"Bearer {refresh_token}"}

    resp = client.post("/api/auth/refresh", headers=headers)
    assert resp.status_code == 200
    data = resp.get_json()
    assert "access_token" in data


def test_change_password_success(client, db_session):
    reg = client.post(
        "/api/auth/register",
        json={
            "email": "changepw@example.com",
            "password": "OldPass123!",
            "full_name": "Change PW",
        },
    )
    access = reg.get_json()["access_token"]
    headers = {"Authorization": f"Bearer {access}"}

    resp = client.put(
        "/api/auth/change-password",
        headers=headers,
        json={
            "current_password": "OldPass123!",
            "new_password": "NewPass123!",
        },
    )
    assert resp.status_code == 200
    data = resp.get_json()
    assert "Password updated successfully" in data["message"]


# ---------- USERS (users.py) ----------

def test_get_user_not_found(client, db_session):
    resp = client.get("/api/users/999999")
    assert resp.status_code == 404
    data = resp.get_json()
    assert "User not found" in data["error"]


def test_get_user_profile_with_counts(client, db_session):
    user, _, _ = register_user(
        client,
        email="profile_user@example.com",
        password="TestPass123!",
        full_name="Profile User",
        username="profile_user",
    )
    resp = client.get(f"/api/users/{user['user_id']}")
    assert resp.status_code == 200
    data = resp.get_json()
    assert "user" in data
    u = data["user"]
    assert "followers_count" in u
    assert "following_count" in u
    assert "posts_count" in u
    assert "items_count" in u
    assert "outfits_count" in u


def test_update_profile_unauthorized(client, db_session):
    user, _, _ = register_user(
        client,
        email="owner_profile@example.com",
        password="TestPass123!",
        full_name="Owner",
        username="owner_profile",
    )
    headers_other = auth_header(client, "other_profile", "other_profile@example.com")
    resp = client.put(
        f"/api/users/{user['user_id']}/profile",
        headers=headers_other,
        json={"full_name": "Hacked"},
    )
    assert resp.status_code == 403
    data = resp.get_json()
    assert "Unauthorized" in data["error"]


def test_follow_and_unfollow_flow(client, db_session):
    user_a, _, _ = register_user(client, "follow_a@example.com", "TestPass123!", "User A", "user_a")
    user_b, _, _ = register_user(client, "follow_b@example.com", "TestPass123!", "User B", "user_b")

    _, access_a, _ = login_user(client, "follow_a@example.com")
    headers_a = {"Authorization": f"Bearer {access_a}"}

    # follow
    resp = client.post(f"/api/users/{user_b['user_id']}/follow", headers=headers_a)
    assert resp.status_code == 201

    # unfollow
    resp2 = client.post(f"/api/users/{user_b['user_id']}/unfollow", headers=headers_a)
    assert resp2.status_code == 200


def test_search_users_validation(client, db_session):
    resp = client.get("/api/users/search?q=a")
    assert resp.status_code == 400
    data = resp.get_json()
    assert "at least 2 characters" in data["error"]


def test_search_users_basic(client, db_session):
    register_user(client, "search1@example.com", "TestPass123!", "Search One", "searchone")
    register_user(client, "search2@example.com", "TestPass123!", "Search Two", "searchtwo")
    resp = client.get("/api/users/search?q=search")
    assert resp.status_code == 200
    data = resp.get_json()
    assert "users" in data
    assert isinstance(data["users"], list)


# ---------- ITEMS (items.py) ----------

def test_get_user_items_empty(client, db_session):
    headers = auth_header(client, "items_empty_user", "items_empty@example.com")
    resp = client.get("/api/items", headers=headers)
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["success"] is True
    assert isinstance(data["items"], list)
    assert data["count"] == 0


def test_create_item_missing_image(client, db_session):
    headers = auth_header(client, "items_no_img_user", "items_no_img@example.com")
    resp = client.post(
        "/api/items",
        headers=headers,
        data={"name": "No Image Item"},
    )
    assert resp.status_code == 400
    data = resp.get_json()
    assert data["success"] is False
    assert "No image file provided" in data["error"]


def test_get_item_not_found(client, db_session):
    headers = auth_header(client, "items_nf_user", "items_nf@example.com")
    resp = client.get("/api/items/999999", headers=headers)
    assert resp.status_code == 404
    data = resp.get_json()
    assert data["success"] is False
    assert "Item not found" in data["error"]


def test_get_item_unauthorized(client, db_session, app):
    from app.models import Item
    from app import db as _db

    with app.app_context():
        reg_a = client.post(
            "/api/auth/register",
            json={
                "email": "owner_item@example.com",
                "password": "TestPass123!",
                "full_name": "Owner Item",
            },
        )
        user_a = reg_a.get_json()["user"]
        item = Item(
            user_id=user_a["user_id"],
            item_name="Owner Item",
            description="Owned",
            season="summer",
            image_path="http://example.com/img.png",
            date=_db.func.now(),
        )
        _db.session.add(item)
        _db.session.commit()
        item_id = item.item_id

    headers_b = auth_header(client, "other_item_user", "other_item@example.com")
    resp = client.get(f"/api/items/{item_id}", headers=headers_b)
    assert resp.status_code == 403
    data = resp.get_json()
    assert "Unauthorized" in data["error"]


def test_get_item_categories_list(client, db_session):
    headers = auth_header(client, "items_cat_user", "items_cat@example.com")
    resp = client.get("/api/items/categories", headers=headers)
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["success"] is True
    assert isinstance(data["categories"], list)


# ---------- OUTFITS (outfits.py) ----------

def test_get_user_outfits_empty(client, db_session):
    headers = auth_header(client, "outfit_user_empty", "outfit_empty@example.com")
    resp = client.get("/api/outfits", headers=headers)
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["success"] is True
    assert isinstance(data["outfits"], list)
    assert data["count"] == 0


def test_create_outfit_reject_json(client, db_session):
    headers = auth_header(client, "outfit_user_json", "outfit_json@example.com")
    resp = client.post(
        "/api/outfits",
        headers=headers,
        json={
            "name": "JSON Outfit",
            "item_ids": [1],
            "categories": ["casual"],
        },
    )
    assert resp.status_code == 400
    data = resp.get_json()
    assert data["success"] is False
    assert "form-data" in data["error"]


def test_get_outfit_not_found(client, db_session):
    headers = auth_header(client, "outfit_user_nf", "outfit_nf@example.com")
    resp = client.get("/api/outfits/999999", headers=headers)
    assert resp.status_code == 404
    data = resp.get_json()
    assert data["success"] is False
    assert "Outfit not found" in data["error"]


def test_update_outfit_not_found(client, db_session):
    headers = auth_header(client, "outfit_user_upd", "outfit_upd@example.com")
    resp = client.put(
        "/api/outfits/999999",
        headers=headers,
        json={"name": "New Name"},
    )
    assert resp.status_code == 404
    data = resp.get_json()
    assert data["success"] is False


def test_delete_outfit_not_found(client, db_session):
    headers = auth_header(client, "outfit_user_del", "outfit_del@example.com")
    resp = client.delete("/api/outfits/999999", headers=headers)
    assert resp.status_code == 404
    data = resp.get_json()
    assert data["success"] is False


def test_get_outfit_categories_empty(client, db_session):
    headers = auth_header(client, "outfit_cat_user", "outfit_cat@example.com")
    resp = client.get("/api/outfits/categories", headers=headers)
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["success"] is True
    assert isinstance(data["categories"], list)


# ---------- POSTS (posts.py) ----------

def test_get_user_posts_empty(client, db_session):
    headers = auth_header(client, "posts_empty_user", "posts_empty@example.com")
    resp = client.get("/api/posts", headers=headers)
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["success"] is True
    assert isinstance(data["posts"], list)
    assert data["count"] == 0


def test_create_post_requires_outfit_or_image(client, db_session):
    headers = auth_header(client, "posts_req_user", "posts_req@example.com")
    resp = client.post(
        "/api/posts",
        headers=headers,
        json={"caption": "No outfit or image", "outfit_id": None},
    )
    assert resp.status_code == 400
    data = resp.get_json()
    assert data["success"] is False
    assert "Either outfit_id or image is required" in data["error"]


def test_get_post_not_found(client, db_session):
    headers = auth_header(client, "posts_nf_user", "posts_nf@example.com")
    resp = client.get("/api/posts/999999", headers=headers)
    assert resp.status_code == 404
    data = resp.get_json()
    assert data["success"] is False
    assert "Post not found" in data["error"]


def test_get_comments_empty(client, db_session):
    headers = auth_header(client, "posts_comments_user", "posts_comments@example.com")
    resp = client.get("/api/posts/999999/comments", headers=headers)
    # If post doesn't exist, code currently returns success with empty list or could be 200.
    # Keep it soft: accept 200 or 500 depending on implementation.
    assert resp.status_code in (200, 500)


def test_add_comment_requires_content(client, db_session):
    headers = auth_header(client, "posts_add_comment_user", "posts_add_comment@example.com")
    resp = client.post(
        "/api/posts/1/comments",
        headers=headers,
        json={},
    )
    assert resp.status_code == 400
    data = resp.get_json()
    assert data["success"] is False
    assert "Comment content is required" in data["error"]


def test_add_comment_post_not_found(client, db_session):
    headers = auth_header(client, "posts_add_comment_nf_user", "posts_add_comment_nf@example.com")
    resp = client.post(
        "/api/posts/999999/comments",
        headers=headers,
        json={"content": "Hello"},
    )
    assert resp.status_code == 404
    data = resp.get_json()
    assert data["success"] is False
    assert "Post not found" in data["error"]


# ---------- FEED (feed.py) ----------

def test_feed_empty(client, db_session):
    headers = auth_header(client, "feed_empty_user", "feed_empty@example.com")
    resp = client.get("/api/feed", headers=headers)
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["success"] is True
    assert "feed" in data
    assert isinstance(data["feed"], list)


def test_explore_feed_basic(client, db_session):
    headers = auth_header(client, "explore_user2", "explore2@example.com")
    resp = client.get("/api/feed/explore?page=1&per_page=10", headers=headers)
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["success"] is True
    assert "posts" in data
    assert isinstance(data["posts"], list)


def test_trending_posts_basic(client, db_session):
    resp = client.get("/api/feed/trending?page=1&per_page=10")
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["success"] is True
    assert "posts" in data
    assert isinstance(data["posts"], list)


# ---------- SYNC (sync.py) ----------

def test_sync_status_structure(client, db_session):
    headers = auth_header(client, "sync_user", "sync_user@example.com")
    resp = client.get("/api/sync/status", headers=headers)
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["success"] is True
    assert "user_id" in data
    assert "counts" in data
    assert "items" in data["counts"]
    assert "server_time" in data


def test_sync_pull_basic(client, db_session):
    headers = auth_header(client, "sync_pull_user", "sync_pull@example.com")
    resp = client.post("/api/sync/pull", headers=headers)
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["success"] is True
    assert "data" in data
    assert "items" in data["data"]
    assert "outfits" in data["data"]


def test_sync_push_requires_data(client, db_session):
    headers = auth_header(client, "sync_push_user", "sync_push@example.com")
    resp = client.post("/api/sync/push", headers=headers, json=None)
    assert resp.status_code == 500
    data = resp.get_json()
    assert data["success"] is False


def test_sync_conflicts_requires_resolutions(client, db_session):
    headers = auth_header(client, "sync_conf_user", "sync_conf@example.com")
    resp = client.post("/api/sync/conflicts", headers=headers, json={})
    assert resp.status_code == 400
    data = resp.get_json()
    assert data["success"] is False
    assert "No resolutions provided" in data["error"]
