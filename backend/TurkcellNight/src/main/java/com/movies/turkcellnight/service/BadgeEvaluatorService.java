package com.movies.turkcellnight.service;

import com.movies.turkcellnight.entity.*;
import com.movies.turkcellnight.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class BadgeEvaluatorService {

    private final BadgeRepository badgeRepository;
    private final BadgeAwardRepository badgeAwardRepository;
    private final NotificationRepository notificationRepository;

    @Transactional
    public void evaluateAndAssignBadges(UserEntity user) {
        // 1. Fetch all available badges in the system
        List<Badge> allBadges = badgeRepository.findAll();

        // 2. Fetch the badges the user ALREADY owns so we don't give duplicates
        Set<String> ownedBadgeIds = badgeAwardRepository.findByUser_UserId(user.getUserId())
                .stream()
                .map(award -> award.getBadge().getBadgeId())
                .collect(Collectors.toSet());

        // 3. Evaluate each badge
        for (Badge badge : allBadges) {
            // If they already have it, skip!
            if (ownedBadgeIds.contains(badge.getBadgeId())) {
                continue;
            }

            // If the user meets the points requirement, award the badge!
            if (isBadgeConditionMet(user, badge.getConditionRule())) {

                // Save the badge award
                BadgeAward newAward = BadgeAward.builder()
                        .user(user)
                        .badge(badge)
                        .awardedAt(LocalDateTime.now())
                        .build();
                badgeAwardRepository.save(newAward);

                // Send a notification to the user
                Notification notification = Notification.builder()
                        .notificationId("N-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase())
                        .user(user)
                        .channel("BiP")
                        .message("Tebrikler! Yeni bir rozet kazandınız: " + badge.getBadgeName())
                        .sentAt(LocalDateTime.now())
                        .build();
                notificationRepository.save(notification);

                log.info("Awarded badge {} ({}) to User {}", badge.getBadgeId(), badge.getBadgeName(), user.getUserId());
            }
        }
    }

    /**
     * Parses the string condition (e.g., "total_points >= 300") dynamically.
     */
    private boolean isBadgeConditionMet(UserEntity user, String conditionRule) {
        try {
            String[] parts = conditionRule.trim().split("\\s+");
            if (parts.length != 3) return false;

            String metric = parts[0];
            String operator = parts[1];
            int targetValue = Integer.parseInt(parts[2]);

            // We only care about total_points for badges right now
            if (!"total_points".equals(metric)) {
                return false;
            }

            int actualPoints = user.getTotalPoints() != null ? user.getTotalPoints() : 0;

            return switch (operator) {
                case ">=" -> actualPoints >= targetValue;
                case ">"  -> actualPoints > targetValue;
                case "<=" -> actualPoints <= targetValue;
                case "<"  -> actualPoints < targetValue;
                case "==" -> actualPoints == targetValue;
                default -> false;
            };
        } catch (Exception e) {
            log.error("Failed to parse badge condition: {}", conditionRule);
            return false;
        }
    }
}