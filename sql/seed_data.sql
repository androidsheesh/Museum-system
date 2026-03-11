-- ============================================================
-- Avaritia Seed Data
-- ============================================================

USE avaritia_db;

-- ============================================================
-- Demo Users (passwords are bcrypt hash of 'password123')
-- ============================================================
INSERT INTO users (username, email, password_hash, first_name, last_name, role, bio) VALUES
('admin', 'admin@avaritia.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System', 'Admin', 'admin', 'Platform administrator'),
('collector01', 'marcus@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Marcus', 'Aurelius', 'user', 'Passionate collector of ancient Roman artifacts.'),
('antique_hunter', 'elena@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Elena', 'Vasquez', 'user', 'Art historian and antique enthusiast.'),
('bidmaster', 'james@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'James', 'Whitfield', 'user', 'Professional auction bidder with 10 years of experience.'),
('relic_seeker', 'amara@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Amara', 'Okonkwo', 'user', 'Specialist in African and Middle Eastern antiquities.');

-- ============================================================
-- Demo Artifacts
-- ============================================================
INSERT INTO artifacts (title, description, origin, era, category, condition_rating, provenance, added_by, is_verified) VALUES
('Golden Pharaoh Mask', 'An exquisite golden funerary mask from the late Egyptian dynasty period. Intricate hieroglyphic engravings adorn the surface.', 'Egypt', '1300 BC', 'sculpture', 'excellent', 'Discovered in the Valley of the Kings, 1922. Private collection since 1950.', 1, 1),
('Roman Gladius Sword', 'A well-preserved Roman short sword (gladius) with original leather grip and bronze pommel.', 'Roman Empire', '100 AD', 'weapon', 'good', 'Excavated near Pompeii. Authenticated by the Italian Ministry of Culture.', 1, 1),
('Ming Dynasty Vase', 'A blue and white porcelain vase from the Ming Dynasty featuring traditional dragon motifs.', 'China', '1450 AD', 'pottery', 'pristine', 'Imperial collection lineage. Certified by Sotheby''s.', 2, 1),
('Viking Runic Amulet', 'A carved bone amulet featuring Elder Futhark runes, believed to be a protective talisman.', 'Scandinavia', '800 AD', 'jewelry', 'fair', 'Found in a burial mound in Uppsala, Sweden.', 3, 1),
('Renaissance Oil Painting', 'An unsigned oil painting depicting the Annunciation, attributed to the school of Botticelli.', 'Italy', '1480 AD', 'painting', 'good', 'Part of a Florentine noble family collection since the 16th century.', 2, 1),
('Sumerian Cuneiform Tablet', 'A clay tablet inscribed with cuneiform script, recording grain trade transactions.', 'Mesopotamia', '2100 BC', 'manuscript', 'fair', 'Acquired from the British Museum deaccession program, 1998.', 4, 1),
('Aztec Jade Mask', 'A ceremonial jade mask with obsidian and shell inlays, used in religious rituals.', 'Mexico', '1400 AD', 'sculpture', 'excellent', 'Recovered from Templo Mayor excavations, Mexico City.', 5, 1),
('Byzantine Gold Coin', 'A solidus gold coin featuring Emperor Justinian I, in remarkable condition.', 'Byzantine Empire', '530 AD', 'coin', 'pristine', 'Part of a hoard discovered in Istanbul, 1965.', 3, 1),
('Samurai Katana', 'A folded-steel katana with a lacquered scabbard and silk-wrapped tsuka handle.', 'Japan', '1600 AD', 'weapon', 'excellent', 'Tokugawa-era provenance. Certified by the Japanese Sword Museum.', 4, 1),
('Persian Silk Carpet', 'A hand-knotted silk carpet featuring intricate floral and geometric patterns with natural dyes.', 'Persia', '1700 AD', 'textile', 'good', 'Commissioned by the Safavid court. Private European collection.', 5, 1);

-- ============================================================
-- Demo Auctions
-- ============================================================
INSERT INTO auctions (artifact_id, seller_id, title, description, starting_price, reserve_price, current_price, bid_increment, status, start_time, end_time) VALUES
(1, 1, 'Golden Pharaoh Mask — Once in a Lifetime', 'Bid on this extraordinary golden mask from ancient Egypt. Museum-quality piece.', 50000.00, 75000.00, 68000.00, 500.00, 'active', NOW() - INTERVAL 2 DAY, NOW() + INTERVAL 5 DAY),
(2, 1, 'Authentic Roman Gladius', 'A rare chance to own a genuine Roman military sword in remarkable condition.', 8000.00, 12000.00, 11500.00, 250.00, 'active', NOW() - INTERVAL 1 DAY, NOW() + INTERVAL 3 DAY),
(3, 2, 'Imperial Ming Dynasty Vase', 'Pristine blue and white porcelain from the golden age of Chinese ceramics.', 30000.00, 45000.00, 42000.00, 500.00, 'active', NOW(), NOW() + INTERVAL 7 DAY),
(4, 3, 'Viking Protective Amulet', 'Own a piece of Norse history — a genuine runic talisman from the Viking age.', 3000.00, 5000.00, 4200.00, 100.00, 'active', NOW() - INTERVAL 3 DAY, NOW() + INTERVAL 2 DAY),
(5, 2, 'School of Botticelli — The Annunciation', 'A stunning Renaissance oil painting attributed to the workshop of Sandro Botticelli.', 75000.00, 100000.00, 75000.00, 1000.00, 'pending', NOW() + INTERVAL 1 DAY, NOW() + INTERVAL 14 DAY),
(6, 4, 'Ancient Sumerian Trade Record', 'A cuneiform tablet offering a window into the economy of ancient Sumer.', 5000.00, 8000.00, 7500.00, 200.00, 'active', NOW() - INTERVAL 4 DAY, NOW() + INTERVAL 1 DAY),
(9, 4, 'Tokugawa-Era Samurai Katana', 'A masterfully forged katana from Japan''s Edo period with full provenance.', 20000.00, 30000.00, 0.00, 500.00, 'pending', NOW() + INTERVAL 2 DAY, NOW() + INTERVAL 10 DAY);

-- ============================================================
-- Demo Bids
-- ============================================================
INSERT INTO bids (auction_id, bidder_id, bid_amount, is_winning) VALUES
(1, 3, 52000.00, 0),
(1, 4, 58000.00, 0),
(1, 5, 63000.00, 0),
(1, 3, 68000.00, 1),
(2, 2, 8500.00, 0),
(2, 5, 9500.00, 0),
(2, 2, 11000.00, 0),
(2, 4, 11500.00, 1),
(3, 4, 32000.00, 0),
(3, 5, 38000.00, 0),
(3, 3, 42000.00, 1),
(4, 2, 3200.00, 0),
(4, 4, 3800.00, 0),
(4, 2, 4200.00, 1),
(6, 3, 5500.00, 0),
(6, 5, 6500.00, 0),
(6, 2, 7500.00, 1);

-- ============================================================
-- Demo Reports
-- ============================================================
INSERT INTO reports (reporter_id, reported_type, reported_id, reason, details, status) VALUES
(3, 'artifact', 4, 'Questionable authenticity', 'The runic symbols on this amulet appear to be modern reproductions. Requesting expert verification.', 'investigating'),
(5, 'user', 4, 'Suspicious bidding pattern', 'This user appears to be using shill bidding tactics across multiple auctions.', 'open');

-- ============================================================
-- Demo Flagged Items  
-- ============================================================
INSERT INTO flagged_items (item_type, item_id, flag_reason, severity, flagged_by, status) VALUES
('bid', 8, 'Bid jump exceeds normal pattern', 'medium', NULL, 'pending'),
('artifact', 4, 'Authenticity under review', 'high', 1, 'reviewed');
