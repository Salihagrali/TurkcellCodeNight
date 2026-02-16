-- 1. KULLANICILAR (users)
INSERT INTO users (user_id, name, city, segment, total_points) VALUES
                                                                   ('U001', 'Ahmet Yılmaz', 'İstanbul', 'Premium', 0),
                                                                   ('U002', 'Ayşe Demir', 'Ankara', 'Standart', 0),
                                                                   ('U003', 'Mehmet Kaya', 'İzmir', 'Premium', 0);

-- 2. İÇERİKLER VE BÖLÜMLER (shows & episodes)
INSERT INTO shows (show_id, show_name, genre) VALUES
                                                  ('S001', 'Bozkır', 'Crime'),
                                                  ('S002', 'Gibi', 'Comedy');

INSERT INTO episodes (episode_id, show_id, season, episode_no, duration_min) VALUES
                                                                                 ('E001', 'S001', 1, 1, 45),
                                                                                 ('E002', 'S001', 1, 2, 50),
                                                                                 ('E003', 'S002', 1, 1, 30);

-- 3. GÖREVLER VE ROZETLER (challenges & badges)
INSERT INTO challenges (challenge_id, challenge_name, challenge_type, condition_rule, reward_points, priority, is_active) VALUES
                                                                                                                              ('C001', 'Günlük İzleme', 'DAILY', 'watch_minutes_today >= 60', 100, 1, TRUE),
                                                                                                                              ('C002', 'Tür Avcısı', 'DAILY', 'unique_genres_today >= 2', 50, 2, TRUE);

INSERT INTO badges (badge_id, badge_name, condition_rule, level) VALUES
    ('B001', 'Bronz İzleyici', 'total_points >= 150', 1);

-- 4. GÜNLÜK AKTİVİTELER (activity_events & activity_shows)
-- U001 kullanıcısı bugün 2 farklı türde içerik izledi.
INSERT INTO activity_events (event_id, user_id, event_date, unique_genres, watch_minutes, episodes_completed, watch_party_minutes, ratings) VALUES
    ('EV001', 'U001', '2026-03-12', 2, 125, 3, 0, 1);

-- U001'in izlediği diziler
INSERT INTO activity_shows (event_id, show_id) VALUES
                                                   ('EV001', 'S001'),
                                                   ('EV001', 'S002');

-- 5. KULLANICI GÜNLÜK ÖZETİ (user_states)
INSERT INTO user_states (user_id, watch_minutes_today, episodes_completed_today, unique_genres_today, watch_minutes_7d, episodes_completed_7d, ratings_7d, watch_streak_days) VALUES
    ('U001', 125, 3, 2, 400, 8, 2, 4);

-- 6. GÖREV KAZANIMLARI VE ÇAKIŞMA YÖNETİMİ (challenge_awards vb.)
-- U001, C001 ve C002'yi hak etti ama öncelik (priority) kuralı [cite: 67] gereği sadece C001 seçildi.
INSERT INTO challenge_awards (award_id, user_id, as_of_date, selected_challenge_id, reward_points) VALUES
    ('AW001', 'U001', '2026-03-12', 'C001', 100);

-- Hangi görevlerin tetiklendiği ve hangisinin elendiği (suppressed) [cite: 68]
INSERT INTO award_triggered_challenges (award_id, challenge_id) VALUES ('AW001', 'C001'), ('AW001', 'C002');
INSERT INTO award_suppressed_challenges (award_id, challenge_id) VALUES ('AW001', 'C002');

-- 7. PUAN DEFTERİ (points_ledger) -> BURASI TRIGGER'I ÇALIŞTIRACAK!
-- U001, C001'den 100 puan alıyor.
INSERT INTO points_ledger (ledger_id, user_id, points_delta, source, source_ref) VALUES
    ('L001', 'U001', 100, 'CHALLENGE_REWARD', 'AW001');

-- U001'e test için manuel 50 puan daha ekliyoruz (Toplam 150 olacak).
INSERT INTO points_ledger (ledger_id, user_id, points_delta, source, source_ref) VALUES
    ('L002', 'U001', 50, 'BONUS', NULL);

-- U002'ye tek seferde 150 puan ekleyelim (U001 ile eşitlik test için).
INSERT INTO points_ledger (ledger_id, user_id, points_delta, source, source_ref) VALUES
    ('L003', 'U002', 150, 'WELCOME_BONUS', NULL);

-- 8. ROZET VE BİLDİRİM (badge_awards & notifications)
-- U001, 150 puana ulaştığı için Bronz rozet aldı.
INSERT INTO badge_awards (user_id, badge_id) VALUES ('U001', 'B001');

INSERT INTO notifications (notification_id, user_id, channel, message) VALUES
    ('N001', 'U001', 'BiP', 'Günlük İzleme görevini tamamladın ve 100 Puan kazandın!');