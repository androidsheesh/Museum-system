DROP PROCEDURE IF EXISTS place_bid;

CREATE PROCEDURE place_bid(
    IN p_auction_id INT,
    IN p_bidder_id INT,
    IN p_bid_amount DECIMAL(12,2),
    OUT p_result INT
)
BEGIN
    DECLARE v_status VARCHAR(20);
    DECLARE v_current_price DECIMAL(12,2);
    DECLARE v_bid_increment DECIMAL(10,2);
    DECLARE v_seller_id INT;

    SELECT status, current_price, bid_increment, seller_id
    INTO v_status, v_current_price, v_bid_increment, v_seller_id
    FROM auctions
    WHERE auction_id = p_auction_id;

    IF v_status != 'active' THEN
        SET p_result = 0;
    ELSEIF p_bidder_id = v_seller_id THEN
        SET p_result = -2;
    ELSEIF p_bid_amount < (v_current_price + v_bid_increment) THEN
        SET p_result = -1;
    ELSE

        UPDATE bids
        SET is_winning = 0
        WHERE auction_id = p_auction_id
        AND is_winning = 1;

        INSERT INTO bids (auction_id, bidder_id, bid_amount, is_winning)
        VALUES (p_auction_id, p_bidder_id, p_bid_amount, 1);

        UPDATE auctions
        SET current_price = p_bid_amount
        WHERE auction_id = p_auction_id;

        SET p_result = 1;

    END IF;
END;

/**/

DROP PROCEDURE IF EXISTS close_auction;

CREATE PROCEDURE close_auction(
    IN p_auction_id INT,
    OUT p_result INT
)
BEGIN
    DECLARE v_winner_id INT;
    DECLARE v_winning_amount DECIMAL(12,2);
    DECLARE v_reserve DECIMAL(12,2);
    DECLARE v_status VARCHAR(20);

    SELECT status, reserve_price
    INTO v_status, v_reserve
    FROM auctions
    WHERE auction_id = p_auction_id;

    IF v_status = 'closed' THEN
        SET p_result = 0;
    ELSE

        SELECT bidder_id, bid_amount
        INTO v_winner_id, v_winning_amount
        FROM bids
        WHERE auction_id = p_auction_id
        AND is_winning = 1
        LIMIT 1;

        IF v_winner_id IS NOT NULL AND
           (v_reserve IS NULL OR v_winning_amount >= v_reserve) THEN

            INSERT INTO wins (auction_id, winner_id, winning_bid)
            VALUES (p_auction_id, v_winner_id, v_winning_amount);

            UPDATE auctions
            SET status = 'closed'
            WHERE auction_id = p_auction_id;

            SET p_result = 1;

        ELSE

            UPDATE auctions
            SET status = 'closed'
            WHERE auction_id = p_auction_id;

            SET p_result = 2;

        END IF;

    END IF;
END;

/**/

DROP PROCEDURE IF EXISTS register_user;

CREATE PROCEDURE register_user(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    OUT p_result INT,
    OUT p_user_id INT
)
BEGIN
    DECLARE v_exists INT;

    SELECT COUNT(*)
    INTO v_exists
    FROM users
    WHERE username = p_username
    OR email = p_email;

    IF v_exists > 0 THEN
        SET p_result = 0;
        SET p_user_id = 0;
    ELSE

        INSERT INTO users
        (username, email, password_hash, first_name, last_name)
        VALUES
        (p_username, p_email, p_password_hash, p_first_name, p_last_name);

        SET p_user_id = LAST_INSERT_ID();
        SET p_result = 1;

    END IF;
END;

/**/

DROP PROCEDURE IF EXISTS get_auction_details;

CREATE PROCEDURE get_auction_details(
    IN p_auction_id INT
)
BEGIN

    SELECT
        a.*,
        art.title AS artifact_title,
        art.image_url AS artifact_image,
        art.category,
        art.condition_rating,
        u.username AS seller_name,
        COUNT(b.bid_id) AS total_bids,
        MAX(b.bid_amount) AS highest_bid

    FROM auctions a
    JOIN artifacts art
        ON a.artifact_id = art.artifact_id

    JOIN users u
        ON a.seller_id = u.user_id

    LEFT JOIN bids b
        ON a.auction_id = b.auction_id

    WHERE a.auction_id = p_auction_id
    GROUP BY a.auction_id;

END;

/**/

