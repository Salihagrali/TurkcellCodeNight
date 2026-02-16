-- 1. USERS
INSERT INTO users (user_id, name, city, segment, total_points) VALUES
                                                                   ('U001', 'Ahmet Yılmaz', 'İstanbul', 'Premium', 250),
                                                                   ('U002', 'Ayşe Demir', 'Ankara', 'Standart', 300),
                                                                   ('U003', 'Mehmet Kaya', 'İzmir', 'Premium', 50),
                                                                   ('U004', 'Canan Öz', 'Bursa', 'Standart', 0),
                                                                   ('U005', 'Burak Ak', 'Antalya', 'Premium', 120);

-- 2. SHOWS
INSERT INTO shows (show_id, show_name, genre) VALUES
                                                  ('S001', 'Bozkır', 'Crime'),
                                                  ('S002', 'Gibi', 'Comedy'),
                                                  ('S003', 'Hamlet', 'Drama'),
                                                  ('S004', 'Alef', 'Mystery'),
                                                  ('S005', 'Ayak İşleri', 'Comedy');

-- 3. EPISODES
INSERT INTO episodes (episode_id, show_id, season, episode_no, duration_min) VALUES
                                                                                 ('E001', 'S001', 1, 1, 45),
                                                                                 ('E002', 'S001', 1, 2, 50),
                                                                                 ('E003', 'S002', 1, 1, 30),
                                                                                 ('E004', 'S003', 1, 1, 60),
                                                                                 ('E005', 'S005', 1, 1, 25);

-- 4. CHALLENGES
INSERT INTO challenges (challenge_id, challenge_name, challenge_type, condition_rule, reward_points, priority, is_active) VALUES
                                                                                                                              ('C001', 'Günlük İzleme', 'DAILY', 'watch_minutes_today >= 60', 100, 1, TRUE),
                                                                                                                              ('C002', 'Tür Avcısı', 'DAILY', 'unique_genres_today >= 2', 50, 2, TRUE),
                                                                                                                              ('C003', 'Haftalık Binge', 'WEEKLY', 'watch_minutes_7d >= 600', 500, 3, TRUE),
                                                                                                                              ('C004', 'Bölüm Bitirici', 'DAILY', 'episodes_completed_today >= 3', 30, 4, TRUE),
                                                                                                                              ('C005', 'Streak Serisi', 'STREAK', 'watch_streak_days >= 3', 200, 1, TRUE);

-- 5. BADGES
INSERT INTO badges (badge_id, badge_name, condition_rule, level) VALUES
                                                                     ('B001', 'Bronz İzleyici', 'total_points >= 150', 1),
                                                                     ('B002', 'Gümüş İzleyici', 'total_points >= 500', 2),
                                                                     ('B003', 'Altın İzleyici', 'total_points >= 1000', 3),
                                                                     ('B004', 'Komedi Sever', 'total_points >= 100', 1),
                                                                     ('B005', 'Efsane', 'total_points >= 2000', 4);

-- 6. ACTIVITY EVENTS (Multiple days for Streak testing)
INSERT INTO activity_events (event_id, user_id, event_date, unique_genres, watch_minutes, episodes_completed, watch_party_minutes, ratings) VALUES
                                                                                                                                                ('EV001', 'U001', '2026-03-10', 1, 45, 1, 0, 1),
                                                                                                                                                ('EV002', 'U001', '2026-03-11', 1, 50, 1, 0, 0),
                                                                                                                                                ('EV003', 'U001', '2026-03-12', 2, 125, 3, 0, 1),
                                                                                                                                                ('EV004', 'U002', '2026-03-12', 1, 70, 2, 45, 1),
                                                                                                                                                ('EV005', 'U003', '2026-03-12', 1, 35, 1, 0, 0);

-- 7. USER STATES (Initial Snapshots)
INSERT INTO user_states (user_id, watch_minutes_today, episodes_completed_today, unique_genres_today, watch_minutes_7d, episodes_completed_7d, ratings_7d, watch_streak_days) VALUES
                                                                                                                                                                                  ('U001', 125, 3, 2, 220, 5, 2, 3),
                                                                                                                                                                                  ('U002', 70, 2, 1, 500, 12, 5, 5),
                                                                                                                                                                                  ('U003', 35, 1, 1, 100, 3, 1, 1),
                                                                                                                                                                                  ('U004', 0, 0, 0, 0, 0, 0, 0),
                                                                                                                                                                                  ('U005', 45, 1, 1, 300, 6, 2, 2);

-- 8. POINTS LEDGER (This will trigger the total_points update if your DB trigger is active)
INSERT INTO points_ledger (ledger_id, user_id, points_delta, source, source_ref) VALUES
                                                                                     ('L001', 'U001', 100, 'CHALLENGE_REWARD', 'AW001'),
                                                                                     ('L002', 'U002', 200, 'CHALLENGE_REWARD', 'AW002'),
                                                                                     ('L003', 'U003', 50, 'WELCOME_BONUS', NULL),
                                                                                     ('L004', 'U005', 120, 'CHALLENGE_REWARD', 'AW005'),
                                                                                     ('L005', 'U001', 150, 'BONUS', NULL);

-- 9. BADGE AWARDS
INSERT INTO badge_awards (user_id, badge_id) VALUES
                                                 ('U001', 'B001'),
                                                 ('U002', 'B001'),
                                                 ('U002', 'B002'),
                                                 ('U005', 'B004'),
                                                 ('U001', 'B004');

-- 10. NOTIFICATIONS
INSERT INTO notifications (notification_id, user_id, channel, message) VALUES
                                                                           ('N001', 'U001', 'BiP', 'Bronz rozet kazandınız!'),
                                                                           ('N002', 'U002', 'BiP', 'Gümüş rozet kazandınız!'),
                                                                           ('N003', 'U003', 'BiP', 'Hoş geldin bonusu hesabına yüklendi.'),
                                                                           ('N004', 'U005', 'BiP', 'Komedi Sever rozeti kazandınız!'),
                                                                           ('N005', 'U001', 'BiP', 'Günlük İzleme görevi tamamlandı.');