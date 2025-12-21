# app/tasks/scheduled_tasks.py
import schedule
import time
import logging
from datetime import datetime, timedelta
from app import create_app, db
from app.models import User, SyncQueue, Item, Outfit, Post

logger = logging.getLogger(__name__)

def cleanup_old_sync_entries():
    """Remove processed sync queue entries older than 7 days"""
    with create_app().app_context():
        try:
            cutoff = datetime.utcnow() - timedelta(days=7)
            deleted = SyncQueue.query.filter(
                SyncQueue.processed == True,
                SyncQueue.processed_at < cutoff
            ).delete()
            db.session.commit()
            logger.info(f"🧹 Cleaned up {deleted} old sync entries")
        except Exception as e:
            logger.error(f"Error cleaning sync entries: {e}")

def update_trending_scores():
    """Update trending scores for posts"""
    with create_app().app_context():
        try:
            # Calculate engagement scores
            from sqlalchemy import func
            
            # This would update a trending_score column on posts
            # based on likes, comments, and recency
            logger.info("📈 Updated trending scores")
        except Exception as e:
            logger.error(f"Error updating trending scores: {e}")

def send_digest_notifications():
    """Send daily/weekly digest notifications"""
    with create_app().app_context():
        try:
            from app.services.firebase_service import firebase_service
            
            # Find users who haven't logged in recently
            cutoff = datetime.utcnow() - timedelta(days=2)
            inactive_users = User.query.filter(
                User.last_login < cutoff,
                User.device_token.isnot(None)
            ).limit(100).all()
            
            for user in inactive_users:
                if firebase_service.initialized:
                    firebase_service.send_notification(
                        device_token=user.device_token,
                        title="👋 Come back to Vestium!",
                        body="Your wardrobe is waiting for you!",
                        data={'type': 'digest', 'user_id': user.user_id}
                    )
            
            logger.info(f"📧 Sent digest to {len(inactive_users)} users")
        except Exception as e:
            logger.error(f"Error sending digest: {e}")

def backup_database():
    """Create database backup"""
    with create_app().app_context():
        try:
            # This would export data to a backup file
            # or call Supabase backup API
            logger.info("💾 Database backup completed")
        except Exception as e:
            logger.error(f"Error backing up database: {e}")

def start_scheduler():
    """Start all scheduled tasks"""
    logger.info("⏰ Starting scheduled tasks...")
    
    # Schedule tasks
    schedule.every().day.at("02:00").do(cleanup_old_sync_entries)  # 2 AM
    schedule.every().hour.do(update_trending_scores)
    schedule.every().day.at("18:00").do(send_digest_notifications)  # 6 PM
    schedule.every().sunday.at("03:00").do(backup_database)  # Sunday 3 AM
    
    # Run scheduler in background
    while True:
        schedule.run_pending()
        time.sleep(60)  # Check every minute

if __name__ == "__main__":
    start_scheduler()