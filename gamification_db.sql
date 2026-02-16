
CREATE DATABASE IF NOT EXISTS gamification_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE gamification_db;



-- ==========================================
-- 1. CORE ENTITIES (No Dependencies)
-- ==========================================

CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    segment VARCHAR(50),
    total_points INT DEFAULT 0,
    INDEX idx_total_points (total_points DESC) -- Critical for Leaderboard
);

CREATE TABLE shows (
    show_id VARCHAR(50) PRIMARY KEY,
    show_name VARCHAR(255) NOT NULL,
    genre VARCHAR(50)
);

CREATE TABLE challenges (
    challenge_id VARCHAR(50) PRIMARY KEY,
    challenge_name VARCHAR(100) NOT NULL,
    challenge_type ENUM('DAILY', 'WEEKLY', 'STREAK') NOT NULL,
    condition_rule VARCHAR(255) NOT NULL, -- 'condition' is a reserved keyword in SQL
    reward_points INT NOT NULL,
    priority INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE badges (
    badge_id VARCHAR(50) PRIMARY KEY,
    badge_name VARCHAR(100) NOT NULL,
    condition_rule VARCHAR(255) NOT NULL,
    level INT NOT NULL
);

-- ==========================================
-- 2. CATALOG & ACTIVITY (Dependencies: shows, users)
-- ==========================================

CREATE TABLE episodes (
    episode_id VARCHAR(50) PRIMARY KEY,
    show_id VARCHAR(50) NOT NULL,
    season INT NOT NULL,
    episode_no INT NOT NULL,
    duration_min INT NOT NULL,
    FOREIGN KEY (show_id) REFERENCES shows(show_id) ON DELETE CASCADE
);

CREATE TABLE activity_events (
    event_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    event_date DATE NOT NULL,
    unique_genres INT DEFAULT 0,
    watch_minutes INT DEFAULT 0,
    episodes_completed INT DEFAULT 0,
    watch_party_minutes INT DEFAULT 0,
    ratings INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX idx_user_date (user_id, event_date) -- Speeds up 7-day/streak calculations
);

-- Normalized Junction Table for 'shows_watched' (e.g., resolving S1|S2|S3)
CREATE TABLE activity_shows (
    event_id VARCHAR(50) NOT NULL,
    show_id VARCHAR(50) NOT NULL,
    PRIMARY KEY (event_id, show_id),
    FOREIGN KEY (event_id) REFERENCES activity_events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (show_id) REFERENCES shows(show_id) ON DELETE CASCADE
);

-- ==========================================
-- 3. GAMIFICATION ENGINE LOGS & STATE
-- ==========================================

CREATE TABLE challenge_awards (
    award_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    as_of_date DATE NOT NULL,
    selected_challenge_id VARCHAR(50) NOT NULL,
    reward_points INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (selected_challenge_id) REFERENCES challenges(challenge_id)
);

-- Normalized Junction for 'triggered_challenges' (resolving C-05|C-03|C-01)
CREATE TABLE award_triggered_challenges (
    award_id VARCHAR(50) NOT NULL,
    challenge_id VARCHAR(50) NOT NULL,
    PRIMARY KEY (award_id, challenge_id),
    FOREIGN KEY (award_id) REFERENCES challenge_awards(award_id) ON DELETE CASCADE,
    FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id) ON DELETE CASCADE
);

-- Normalized Junction for 'suppressed_challenges' (resolving C-03|C-01)
CREATE TABLE award_suppressed_challenges (
    award_id VARCHAR(50) NOT NULL,
    challenge_id VARCHAR(50) NOT NULL,
    PRIMARY KEY (award_id, challenge_id),
    FOREIGN KEY (award_id) REFERENCES challenge_awards(award_id) ON DELETE CASCADE,
    FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id) ON DELETE CASCADE
);

CREATE TABLE challenge_decisions (
    decision_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    as_of_date DATE NOT NULL,
    selected_reward_points INT NOT NULL,
    reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ==========================================
-- 4. FINANCIAL LEDGER & REWARDS
-- ==========================================

CREATE TABLE points_ledger (
    ledger_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    points_delta INT NOT NULL,
    source VARCHAR(50) NOT NULL, -- e.g., 'CHALLENGE_REWARD'
    source_ref VARCHAR(50), -- Links back to award_id (AW-500)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE badge_awards (
    user_id VARCHAR(50) NOT NULL,
    badge_id VARCHAR(50) NOT NULL,
    awarded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, badge_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (badge_id) REFERENCES badges(badge_id)
);

CREATE TABLE notifications (
    notification_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    channel VARCHAR(50) DEFAULT 'BiP',
    message TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ==========================================
-- 5. DERIVED DAILY STATE (Historical Snapshots)
-- ==========================================

CREATE TABLE user_states (
    user_id VARCHAR(50) PRIMARY KEY, -- Removed as_of_date, user_id is now the sole PK
    watch_minutes_today INT DEFAULT 0,
    episodes_completed_today INT DEFAULT 0,
    unique_genres_today INT DEFAULT 0,
    watch_party_minutes_today INT DEFAULT 0,
    ratings_today INT DEFAULT 0,
    watch_minutes_7d INT DEFAULT 0,
    episodes_completed_7d INT DEFAULT 0,
    ratings_7d INT DEFAULT 0,
    watch_streak_days INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE VIEW vw_leaderboard AS
SELECT 
    RANK() OVER (ORDER BY total_points DESC, user_id ASC) as rank_position,
    user_id,
    name,
    total_points
FROM 
    users;
    
    
DELIMITER //

CREATE TRIGGER trg_update_total_points
AFTER INSERT ON points_ledger
FOR EACH ROW
BEGIN
    UPDATE users
    SET total_points = total_points + NEW.points_delta
    WHERE user_id = NEW.user_id;
END;
//

DELIMITER ;







