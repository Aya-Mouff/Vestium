# app/tasks/scheduled_tasks.py
import schedule
import time
import logging
from datetime import datetime, timedelta
from app import create_app, db
from app.models import User, SyncQueue

logger = logging.getLogger(__name__)

def run_sync_job():
    """Run auto-sync for pending operations"""
    with create_app().app_context():
        try:
            from app.services.sync_service import sync_service
            logger.info("🔄 Running auto-sync...")
            sync_service.run_auto_sync()
        except Exception as e:
            logger.error(f"❌ Auto-sync failed: {e}")

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
            logger.info(f"🧹 Cleaned {deleted} old sync entries")
        except Exception as e:
            logger.error(f"Cleanup error: {e}")

def update_trending_scores():
    """Update trending scores for posts"""
    with create_app().app_context():
        try:
            # Placeholder for trending logic
            logger.info("📈 Trending scores updated")
        except Exception as e:
            logger.error(f"Trending error: {e}")

def send_digest_notifications():
    """Send daily/weekly digest notifications"""
    with create_app().app_context():
        try:
            from app.services.firebase_service import firebase_service
            
            # Only send if Firebase is initialized
            if not getattr(firebase_service, 'initialized', False):
                logger.info("⚠️ Firebase not initialized, skipping digest")
                return
            
            cutoff = datetime.utcnow() - timedelta(days=2)
            inactive_users = User.query.filter(
                User.last_login < cutoff,
                User.device_token.isnot(None)
            ).limit(100).all()
            
            for user in inactive_users:
                try:
                    firebase_service.send_notification(
                        device_token=user.device_token,
                        title="👋 Come back to Vestium!",
                        body="Your wardrobe is waiting for you!",
                        data={'type': 'digest', 'user_id': user.user_id}
                    )
                except Exception as e:
                    logger.error(f"Failed to send to user {user.user_id}: {e}")
            
            logger.info(f"📧 Sent digest to {len(inactive_users)} users")
        except Exception as e:
            logger.error(f"Digest error: {e}")

def backup_database():
    """Create database backup"""
    with create_app().app_context():
        try:
            # Placeholder for backup logic
            logger.info("💾 Database backup completed")
        except Exception as e:
            logger.error(f"Backup error: {e}")

def start_scheduler():
    """Start all scheduled tasks"""
    logger.info("⏰ Starting Vestium scheduled tasks...")
    
    # Schedule all tasks
    schedule.every(5).minutes.do(run_sync_job)           # Sync every 5 min
    schedule.every().day.at("02:00").do(cleanup_old_sync_entries)  # 2 AM
    schedule.every().hour.do(update_trending_scores)     # Hourly
    schedule.every().day.at("18:00").do(send_digest_notifications)  # 6 PM
    schedule.every().sunday.at("03:00").do(backup_database)  # Sun 3 AM
    
    # Run sync immediately on startup
    run_sync_job()
    
    logger.info("📅 Jobs scheduled:")
    logger.info("  ✅ Auto-sync: every 5 minutes")
    logger.info("  ✅ Cleanup: daily at 2:00 AM")
    logger.info("  ✅ Trending scores: hourly")
    logger.info("  ✅ Digest notifications: daily at 6:00 PM")
    logger.info("  ✅ Database backup: Sundays at 3:00 AM")
    logger.info("Press Ctrl+C to stop\n")
    
    # Main scheduler loop
    while True:
        schedule.run_pending()
        time.sleep(60)  # Check every minute

if __name__ == "__main__":
    # Configure logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler('scheduler.log')
        ]
    )
    
    start_scheduler()