package com.movies.turkcellnight.service;

import com.movies.turkcellnight.dto.UserDashboardDTO;
import com.movies.turkcellnight.entity.UserEntity;
import com.movies.turkcellnight.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final UserRepository userRepository;
    private final UserStateRepository userStateRepository;
    private final ChallengeAwardRepository challengeAwardRepository;
    private final BadgeAwardRepository badgeAwardRepository;
    private final NotificationRepository notificationRepository;

    // Hedef: Kullanıcı Listesi ve Total Points
    public List<UserEntity> getAllUsersWithPoints() {
        return userRepository.findAll(); // User entity'sinde zaten totalPoints var
    }

    // Hedef: Leaderboard (Total Points'e göre azalan, eşitlikte isme/ID'ye göre artan)
    public List<UserEntity> getLeaderboard() {
        return userRepository.getLeaderboard();
        // Not: UserRepository içinde @Query("SELECT u FROM User u ORDER BY u.totalPoints DESC, u.userId ASC") şeklinde tanımlanmış olmalı.
    }

    // Hedef: Kullanıcı Detayı (Metrikler, Challenge'lar, Rozetler, Bildirimler)
    public UserDashboardDTO getUserDashboardDetail(String userId) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Kullanıcı bulunamadı: " + userId));

        return UserDashboardDTO.builder()
                .user(user)
                .state(userStateRepository.findById(userId).orElse(null))
                .challengeHistory(challengeAwardRepository.findByUser_UserId(userId))
                .badges(badgeAwardRepository.findByUser_UserId(userId))
                .notifications(notificationRepository.findByUser_UserIdOrderBySentAtDesc(userId))
                .build();
    }
}