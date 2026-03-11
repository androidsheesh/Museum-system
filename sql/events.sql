-- ============================================================
-- Avaritia Scheduled Events
-- ============================================================

USE avaritia_db;

-- Enable the event scheduler
SET GLOBAL event_scheduler = ON;

-- ============================================================
-- Auto-close expired auctions (runs every minute)
-- ============================================================
CREATE EVENT IF NOT EXISTS evt_close_expired_auctions
ON SCHEDULE EVERY 1 MINUTE
DO
UPDATE auctions
SET status = 'closed'
WHERE status = 'active'
AND end_time <= NOW();


-- ============================================================
-- Auto-activate pending auctions when start time is reached
-- ============================================================
CREATE EVENT IF NOT EXISTS evt_activate_pending_auctions
ON SCHEDULE EVERY 1 MINUTE
DO
UPDATE auctions
SET status = 'active'
WHERE status = 'pending'
AND start_time <= NOW()
AND end_time > NOW();


-- ============================================================
-- Cleanup old audit logs (runs daily)
-- ============================================================
CREATE EVENT IF NOT EXISTS evt_cleanup_audit_logs
ON SCHEDULE EVERY 1 DAY
DO
DELETE FROM audit_log
WHERE created_at < NOW() - INTERVAL 90 DAY;


-- ============================================================
-- Generate daily report summary (runs daily at midnight)
-- ============================================================
CREATE EVENT IF NOT EXISTS evt_daily_summary
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_DATE + INTERVAL 1 DAY)
DO
INSERT INTO audit_log (action, table_name, new_values)
VALUES (
    'DAILY_SUMMARY',
    'system',
    JSON_OBJECT(
        'active_auctions', (SELECT COUNT(*) FROM auctions WHERE status = 'active'),
        'total_bids_today', (SELECT COUNT(*) FROM bids WHERE DATE(created_at) = CURDATE()),
        'new_users_today', (SELECT COUNT(*) FROM users WHERE DATE(created_at) = CURDATE()),
        'closed_today', (SELECT COUNT(*) FROM auctions WHERE status = 'closed' AND DATE(updated_at) = CURDATE())
    )
);