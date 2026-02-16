-- ==========================================
-- 1. KULLANICILAR (users)
-- ==========================================
INSERT INTO users (user_id, name, city, segment, total_points) VALUES
                                                                   ('U001', 'Ahmet Yılmaz', 'İstanbul', 'Premium', 250),
                                                                   ('U002', 'Ayşe Demir', 'Ankara', 'Standart', 300),
                                                                   ('U003', 'Mehmet Kaya', 'İzmir', 'Premium', 50),
                                                                   ('U004', 'Canan Öz', 'Bursa', 'Standart', 0),
                                                                   ('U005', 'Burak Ak', 'Antalya', 'Premium', 120),
-- Yüksek Puanlı Yeni Kullanıcılar (Whale Users)
                                                                   ('U006', 'Kerem Bursin', 'İstanbul', 'Premium', 900),
                                                                   ('U007', 'Haluk Bilginer', 'İzmir', 'Premium', 1850),
                                                                   ('U008', 'Gülse Birsel', 'Ankara', 'Premium', 2100);

-- ==========================================
-- 2. İÇERİKLER (shows)
-- ==========================================
INSERT INTO shows (show_id, show_name, genre) VALUES
                                                  ('S001', 'Bozkır', 'Crime'),
                                                  ('S002', 'Gibi', 'Comedy'),
                                                  ('S003', 'Hamlet', 'Drama'),
                                                  ('S004', 'Alef', 'Mystery'),
                                                  ('S005', 'Ayak İşleri', 'Comedy');

-- ==========================================
-- 3. BÖLÜMLER (episodes)
-- ==========================================
INSERT INTO episodes (episode_id, show_id, season, episode_no, duration_min) VALUES
                                                                                 ('E001', 'S001', 1, 1, 45),
                                                                                 ('E002', 'S001', 1, 2, 50),
                                                                                 ('E003', 'S002', 1, 1, 30),
                                                                                 ('E004', 'S003', 1, 1, 60),
                                                                                 ('E005', 'S005', 1, 1, 25);

-- ==========================================
-- 4. GÖREVLER (challenges)
-- ==========================================
INSERT INTO challenges (challenge_id, challenge_name, challenge_type, condition_rule, reward_points, priority, is_active) VALUES
                                                                                                                              ('C001', 'Günlük İzleme', 'DAILY', 'watch_minutes_today >= 60', 100, 1, TRUE),
                                                                                                                              ('C002', 'Tür Avcısı', 'DAILY', 'unique_genres_today >= 2', 50, 2, TRUE),
                                                                                                                              ('C003', 'Haftalık Binge', 'WEEKLY', 'watch_minutes_7d >= 600', 500, 3, TRUE),
                                                                                                                              ('C004', 'Bölüm Bitirici', 'DAILY', 'episodes_completed_today >= 3', 30, 4, TRUE),
                                                                                                                              ('C005', 'Streak Serisi', 'STREAK', 'watch_streak_days >= 3', 200, 1, TRUE);

-- ==========================================
-- 5. ROZETLER (badges)
-- ==========================================
INSERT INTO badges (badge_id, badge_name, condition_rule, level) VALUES
                                                                     ('B001', 'Bronz İzleyici', 'total_points >= 150', 1),
                                                                     ('B002', 'Gümüş İzleyici', 'total_points >= 500', 2),
                                                                     ('B003', 'Altın İzleyici', 'total_points >= 1000', 3),
                                                                     ('B004', 'Komedi Sever', 'total_points >= 100', 1),
                                                                     ('B005', 'Efsane', 'total_points >= 2000', 4);

-- ==========================================
-- 6. GÜNLÜK AKTİVİTELER (activity_events)
-- ==========================================
INSERT INTO activity_events (event_id, user_id, event_date, unique_genres, watch_minutes, episodes_completed, watch_party_minutes, ratings) VALUES
                                                                                                                                                ('EV001', 'U001', '2026-03-10', 1, 45, 1, 0, 1),
                                                                                                                                                ('EV002', 'U001', '2026-03-11', 1, 50, 1, 0, 0),
                                                                                                                                                ('EV003', 'U001', '2026-03-12', 2, 125, 3, 0, 1),
                                                                                                                                                ('EV004', 'U002', '2026-03-12', 1, 70, 2, 45, 1),
                                                                                                                                                ('EV005', 'U003', '2026-03-12', 1, 35, 1, 0, 0),
-- Yüksek Puanlı Kullanıcı Aktiviteleri
                                                                                                                                                ('EV006', 'U006', '2026-03-12', 3, 240, 5, 60, 2),
                                                                                                                                                ('EV007', 'U007', '2026-03-12', 2, 300, 6, 0, 5),
                                                                                                                                                ('EV008', 'U008', '2026-03-12', 4, 450, 10, 120, 3);

-- ==========================================
-- 7. İZLENEN DİZİLER (activity_shows)
-- ==========================================
INSERT INTO activity_shows (event_id, show_id) VALUES
                                                   ('EV001', 'S001'),
                                                   ('EV002', 'S001'),
                                                   ('EV003', 'S001'), ('EV003', 'S002'),
                                                   ('EV004', 'S002'), ('EV004', 'S005'),
                                                   ('EV005', 'S003'),
                                                   ('EV006', 'S001'), ('EV006', 'S003'), ('EV006', 'S004'),
                                                   ('EV007', 'S001'), ('EV007', 'S004'),
                                                   ('EV008', 'S002'), ('EV008', 'S005');

-- ==========================================
-- 8. KULLANICI GÜNLÜK ÖZETİ (user_states)
-- ==========================================
INSERT INTO user_states (user_id, watch_minutes_today, episodes_completed_today, unique_genres_today, watch_minutes_7d, episodes_completed_7d, ratings_7d, watch_streak_days) VALUES
                                                                                                                                                                                  ('U001', 125, 3, 2, 220, 5, 2, 3),
                                                                                                                                                                                  ('U002', 70, 2, 1, 500, 12, 5, 5),
                                                                                                                                                                                  ('U003', 35, 1, 1, 100, 3, 1, 1),
                                                                                                                                                                                  ('U004', 0, 0, 0, 0, 0, 0, 0),
                                                                                                                                                                                  ('U005', 45, 1, 1, 300, 6, 2, 2),
-- Yüksek Puanlı Kullanıcı Durumları
                                                                                                                                                                                  ('U006', 240, 5, 3, 1100, 15, 4, 10),
                                                                                                                                                                                  ('U007', 300, 6, 2, 2500, 25, 10, 30),
                                                                                                                                                                                  ('U008', 450, 10, 4, 3200, 40, 15, 45);

-- ==========================================
-- 9. GÖREV KAZANIMLARI (challenge_awards)
-- ==========================================
INSERT INTO challenge_awards (award_id, user_id, as_of_date, selected_challenge_id, reward_points) VALUES
                                                                                                       ('AW006', 'U006', '2026-03-12', 'C001', 100),
                                                                                                       ('AW007', 'U007', '2026-03-12', 'C003', 500),
                                                                                                       ('AW008', 'U008', '2026-03-12', 'C005', 200);

-- Tetiklenen Görevler
INSERT INTO award_triggered_challenges (award_id, challenge_id) VALUES
                                                                    ('AW006', 'C001'), ('AW006', 'C002'), ('AW006', 'C004'),
                                                                    ('AW007', 'C001'), ('AW007', 'C003'),
                                                                    ('AW008', 'C001'), ('AW008', 'C005');

-- Bastırılan Görevler (Suppressed - Çakışma Yönetimi)
INSERT INTO award_suppressed_challenges (award_id, challenge_id) VALUES
                                                                     ('AW006', 'C002'), ('AW006', 'C004'),
                                                                     ('AW007', 'C001'),
                                                                     ('AW008', 'C001');

-- ==========================================
-- 10. PUAN DEFTERİ (points_ledger) -> TÜM TARİHLER EKLENDİ!
-- ==========================================
INSERT INTO points_ledger (ledger_id, user_id, points_delta, source, source_ref, created_at) VALUES
-- U001'in Grafiğini Çizecek 3 Günlük Veri
('L001', 'U001', 50,  'BONUS',            NULL,    '2026-03-10 10:00:00'),
('L002', 'U001', 100, 'CHALLENGE_REWARD', 'AW001', '2026-03-11 14:30:00'),
('L003', 'U001', 100, 'CHALLENGE_REWARD', 'AW002', '2026-03-12 18:45:00'),

-- Diğer Standart Kullanıcılar
('L004', 'U002', 200, 'CHALLENGE_REWARD', 'AW002', '2026-03-11 09:00:00'),
('L005', 'U003', 50,  'WELCOME_BONUS',    NULL,    '2026-03-12 12:00:00'),
('L006', 'U005', 120, 'CHALLENGE_REWARD', 'AW005', '2026-03-12 15:30:00'),

-- Yüksek Puanlı (Whale) Kullanıcılar
('L007', 'U006', 150, 'CHALLENGE_REWARD', 'AW006', '2026-03-12 20:00:00'),
('L008', 'U007', 500, 'CHALLENGE_REWARD', 'AW007', '2026-03-12 20:15:00'),
('L009', 'U008', 200, 'CHALLENGE_REWARD', 'AW008', '2026-03-12 20:30:00');

-- ==========================================
-- 11. ROZET KAZANIMLARI (badge_awards)
-- ==========================================
INSERT INTO badge_awards (user_id, badge_id) VALUES
-- Standart Kullanıcılar
('U001', 'B001'), ('U002', 'B001'), ('U002', 'B002'), ('U005', 'B004'), ('U001', 'B004'),
-- U006 (Kerem) 1050 puanda: Altın, Gümüş, Bronz
('U006', 'B001'), ('U006', 'B002'), ('U006', 'B003'),
-- U007 (Haluk) 2350 puanda: Hepsini aldı
('U007', 'B001'), ('U007', 'B002'), ('U007', 'B003'), ('U007', 'B005'),
-- U008 (Gülse) 2300 puanda: Komedi dahil hepsini aldı
('U008', 'B001'), ('U008', 'B002'), ('U008', 'B003'), ('U008', 'B004'), ('U008', 'B005');

-- ==========================================
-- 12. BİLDİRİMLER (notifications)
-- ==========================================
INSERT INTO notifications (notification_id, user_id, channel, message) VALUES
-- Standart
('N001', 'U001', 'BiP', 'Bronz rozet kazandınız!'),
('N002', 'U002', 'BiP', 'Gümüş rozet kazandınız!'),
('N003', 'U003', 'BiP', 'Hoş geldin bonusu hesabına yüklendi.'),
('N004', 'U005', 'BiP', 'Komedi Sever rozeti kazandınız!'),
('N005', 'U001', 'BiP', 'Günlük İzleme görevi tamamlandı.'),
-- Efsanevi Bildirimler
('N006', 'U006', 'BiP', 'Tebrikler! 1000 Puanı geçerek "Altın İzleyici" oldunuz!'),
('N007', 'U007', 'SMS', 'İnanılmaz! 2000 Puanı aştınız ve artık bir "Efsane"siniz!'),
('N008', 'U008', 'BiP', 'Gülse, tüm rozetleri toplayarak TV+ Efsanesi unvanını kazandın!');