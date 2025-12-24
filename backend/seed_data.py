from app import create_app, db
from app.models import ItemCategory, OutfitCategory

app = create_app()

with app.app_context():
    # Add default item categories
    item_categories = [
        'Tops', 'Bottoms', 'Dresses', 'Outerwear', 'Shoes', 'Accessories'
    ]
    
    for cat_name in item_categories:
        if not ItemCategory.query.filter_by(category_name=cat_name).first():
            category = ItemCategory(category_name=cat_name)
            db.session.add(category)
            print(f"Added item category: {cat_name}")
    
    # Add default outfit categories
    outfit_categories = [
        'Casual', 'Formal', 'Workwear', 'Athletic', 
        'Party', 'Date Night', 'Vacation', 'Seasonal'
    ]
    
    for cat_name in outfit_categories:
        if not OutfitCategory.query.filter_by(category_name=cat_name).first():
            category = OutfitCategory(category_name=cat_name)
            db.session.add(category)
            print(f"Added outfit category: {cat_name}")
    
    db.session.commit()
    print("\n✓ Seed data added successfully!")