package com.movies.turkcellnight.dto;

import com.movies.turkcellnight.entity.*;
import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class UserDashboardDTO {
    // 1. Kullanıcı ve Metrikleri (Today, 7d, Streak)
    private UserEntity user;
    private UserState state;

    // 2. Challenge Geçmişi (Triggered, Selected, Suppressed)
    private List<ChallengeAward> challengeHistory;

    // 3. Kazanılan Rozetler
    private List<BadgeAward> badges;

    // 4. Bildirim Kayıtları
    private List<Notification> notifications;
}