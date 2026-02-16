package com.movies.turkcellnight.service;

import com.movies.turkcellnight.entity.*;
import com.movies.turkcellnight.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChallengeEvaluatorService {

    private final ChallengeRepository challengeRepository;
    private final ChallengeAwardRepository awardRepository;
    private final PointsLedgerRepository ledgerRepository;
    private final UserRepository userRepository;
    private final NotificationRepository notificationRepository;

    @Transactional
    public void evaluateUserChallenges(UserState userState, LocalDate asOfDate) {
        // 1. Fetch all active challenges from the database
        List<Challenge> activeChallenges = challengeRepository.findByIsActiveTrue();
        List<Challenge> triggeredChallenges = new ArrayList<>();

        // 2. Check which challenges the user actually completed today
        for (Challenge challenge : activeChallenges) {
            if (isConditionMet(userState, challenge.getConditionRule())) {
                triggeredChallenges.add(challenge);
            }
        }

        // If no challenges triggered, do nothing.
        if (triggeredChallenges.isEmpty()) {
            return;
        }

        // 3. APPLY CONFLICT MANAGEMENT (Tek Ödül Kuralı)
        // Sort by priority ascending (1 is the highest priority)
        triggeredChallenges.sort(Comparator.comparingInt(Challenge::getPriority));

        // The winner is the first one. The rest are suppressed.
        Challenge selectedChallenge = triggeredChallenges.get(0);
        Set<Challenge> suppressedChallenges = triggeredChallenges.stream()
                .skip(1) // Skip the winner
                .collect(Collectors.toSet());

        // 4. Save the Award Record (with suppressed mapped)
        String awardId = "AW-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        ChallengeAward award = ChallengeAward.builder()
                .awardId(awardId)
                .user(userState.getUser())
                .asOfDate(asOfDate)
                .selectedChallenge(selectedChallenge)
                .rewardPoints(selectedChallenge.getRewardPoints())
                .suppressedChallenges(suppressedChallenges)
                .createdAt(LocalDateTime.now())
                .build();
        awardRepository.save(award);

        // 5. Update the Points Ledger
        PointsLedger ledgerEntry = PointsLedger.builder()
                .ledgerId("L-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase())
                .user(userState.getUser())
                .pointsDelta(selectedChallenge.getRewardPoints())
                .source("CHALLENGE_REWARD")
                .sourceRef(awardId)
                .createdAt(LocalDateTime.now())
                .build();
        ledgerRepository.save(ledgerEntry);

        // 6. Add points to the User's Total Points
        UserEntity user = userState.getUser();
        user.setTotalPoints(user.getTotalPoints() + selectedChallenge.getRewardPoints());
        userRepository.save(user);

        // 7. Generate the Mock Notification
        Notification notification = Notification.builder()
                .notificationId("N-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase())
                .user(user)
                .channel("BiP")
                .message("Kazanım: " + selectedChallenge.getChallengeId() + " tamamlandı. +" + selectedChallenge.getRewardPoints() + " puan.")
                .sentAt(LocalDateTime.now())
                .build();
        notificationRepository.save(notification);

        log.info("User {} awarded {} points for Challenge {}. Suppressed {} challenges.",
                user.getUserId(), selectedChallenge.getRewardPoints(), selectedChallenge.getChallengeId(), suppressedChallenges.size());
    }

    /**
     * Dynamically parses strings like "watch_minutes_today >= 60"
     * and evaluates them against the UserState object.
     */
    private boolean isConditionMet(UserState state, String conditionRule) {
        try {
            // Split "watch_minutes_today >= 60" into ["watch_minutes_today", ">=", "60"]
            String[] parts = conditionRule.trim().split("\\s+");
            if (parts.length != 3) return false;

            String metric = parts[0];
            String operator = parts[1];
            int targetValue = Integer.parseInt(parts[2]);

            // Get the actual value from the user's state
            int actualValue = getMetricValueFromState(state, metric);

            // Evaluate
            return switch (operator) {
                case ">=" -> actualValue >= targetValue;
                case ">"  -> actualValue > targetValue;
                case "<=" -> actualValue <= targetValue;
                case "<"  -> actualValue < targetValue;
                case "==" -> actualValue == targetValue;
                default -> false;
            };
        } catch (Exception e) {
            log.error("Failed to parse condition: {}", conditionRule);
            return false;
        }
    }

    private int getMetricValueFromState(UserState state, String metric) {
        return switch (metric) {
            case "watch_minutes_today" -> state.getWatchMinutesToday();
            case "episodes_completed_today" -> state.getEpisodesCompletedToday();
            case "unique_genres_today" -> state.getUniqueGenresToday();
            case "watch_party_minutes_today" -> state.getWatchPartyMinutesToday();
            case "ratings_today" -> state.getRatingsToday();
            case "watch_minutes_7d" -> state.getWatchMinutes7d();
            case "episodes_completed_7d" -> state.getEpisodesCompleted7d();
            case "ratings_7d" -> state.getRatings7d();
            case "watch_streak_days" -> state.getWatchStreakDays();
            default -> 0;
        };
    }
}