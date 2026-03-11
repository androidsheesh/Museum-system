USE avaritia_db;

DROP FUNCTION IF EXISTS get_highest_bid;

CREATE FUNCTION get_highest_bid(p_auction_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
RETURN (
    SELECT COALESCE(MAX(bid_amount),0)
    FROM bids
    WHERE auction_id = p_auction_id
);

/**/

DROP FUNCTION IF EXISTS get_bid_count;

CREATE FUNCTION get_bid_count(p_auction_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
RETURN (
    SELECT COUNT(*)
    FROM bids
    WHERE auction_id = p_auction_id
);

/**/

DROP FUNCTION IF EXISTS has_user_bid;

CREATE FUNCTION has_user_bid(p_user_id INT, p_auction_id INT)
RETURNS TINYINT
DETERMINISTIC
READS SQL DATA
RETURN (
    SELECT IF(COUNT(*) > 0,1,0)
    FROM bids
    WHERE bidder_id = p_user_id
    AND auction_id = p_auction_id
);