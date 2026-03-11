DROP TRIGGER IF EXISTS trg_auctions_after_insert;

CREATE TRIGGER trg_auctions_after_insert
AFTER INSERT ON auctions
FOR EACH ROW
INSERT INTO audit_log (user_id, action, table_name, record_id, new_values)
VALUES (
    NEW.seller_id,
    'INSERT',
    'auctions',
    NEW.auction_id,
    JSON_OBJECT(
        'title', NEW.title,
        'starting_price', NEW.starting_price,
        'status', NEW.status
    )
);

/**/

DROP TRIGGER IF EXISTS trg_auctions_after_update;

CREATE TRIGGER trg_auctions_after_update
AFTER UPDATE ON auctions
FOR EACH ROW
INSERT INTO audit_log (user_id, action, table_name, record_id, old_values, new_values)
VALUES (
    NEW.seller_id,
    'UPDATE',
    'auctions',
    NEW.auction_id,
    JSON_OBJECT(
        'title', OLD.title,
        'current_price', OLD.current_price,
        'status', OLD.status
    ),
    JSON_OBJECT(
        'title', NEW.title,
        'current_price', NEW.current_price,
        'status', NEW.status
    )
);

/**/

DROP TRIGGER IF EXISTS trg_auctions_after_delete;

CREATE TRIGGER trg_auctions_after_delete
AFTER DELETE ON auctions
FOR EACH ROW
INSERT INTO audit_log (user_id, action, table_name, record_id, old_values)
VALUES (
    OLD.seller_id,
    'DELETE',
    'auctions',
    OLD.auction_id,
    JSON_OBJECT(
        'title', OLD.title,
        'starting_price', OLD.starting_price,
        'status', OLD.status
    )
);

/**/

DROP TRIGGER IF EXISTS trg_bids_after_insert_flag;

CREATE TRIGGER trg_bids_after_insert_flag
AFTER INSERT ON bids
FOR EACH ROW
BEGIN
    DECLARE v_current DECIMAL(12,2);

    SELECT current_price
    INTO v_current
    FROM auctions
    WHERE auction_id = NEW.auction_id;

    IF v_current > 0 AND NEW.bid_amount > (v_current * 2) THEN
        INSERT INTO flagged_items
        (item_type, item_id, flag_reason, severity, status)
        VALUES
        (
            'bid',
            NEW.bid_id,
            CONCAT('Suspicious bid: amount ', NEW.bid_amount,
            ' exceeds 2x current price of ', v_current),
            'high',
            'pending'
        );
    END IF;
END;

/**/

DROP TRIGGER IF EXISTS trg_users_after_update;

CREATE TRIGGER trg_users_after_update
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    IF OLD.role != NEW.role OR OLD.is_active != NEW.is_active THEN
        INSERT INTO audit_log
        (user_id, action, table_name, record_id, old_values, new_values)
        VALUES
        (
            NEW.user_id,
            'UPDATE',
            'users',
            NEW.user_id,
            JSON_OBJECT(
                'role', OLD.role,
                'is_active', OLD.is_active
            ),
            JSON_OBJECT(
                'role', NEW.role,
                'is_active', NEW.is_active
            )
        );
    END IF;
END;