package com.movies.turkcellnight.service;

import com.movies.turkcellnight.dtos.WatchRequest;
import com.movies.turkcellnight.entity.*;
import com.movies.turkcellnight.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class ActivityService {

    private final UserRepository userRepository;
    private final EpisodeRepository episodeRepository;
    private final ShowRepository showRepository;
    private final ActivityEventRepository activityEventRepository;
    private final UserStateRepository userStateRepository;

    // Injecting the Gamification Engines
    private final ChallengeEvaluatorService challengeEvaluator;
    private final BadgeEvaluatorService badgeEvaluator;

    @Transactional
    public void processWatchActivity(WatchRequest request) {
        // 1. Fetch necessary entities
        UserEntity user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));
        Episode episode = episodeRepository.findById(request.getEpisodeId())
                .orElseThrow(() -> new RuntimeException("Episode not found"));
        Show show = showRepository.findById(episode.getShow().getShowId())
                .orElseThrow(() -> new RuntimeException("Show not found"));

        // 2. Log the raw Activity Event for history
        ActivityEvent event = ActivityEvent.builder()
                .eventId("EV-" + UUID.randomUUID().toString().substring(0,8).toUpperCase())
                .user(user)
                .eventDate(request.getEventDate())
                .watchMinutes(episode.getDurationMin())
                .episodesCompleted(1)
                .watchPartyMinutes(request.isWatchParty() ? episode.getDurationMin() : 0)
                .ratings(request.getRating())
                .build();
        activityEventRepository.save(event);

        // 3. Recalculate User State (Today, 7D, Streak)
        UserState state = recalculateUserState(user, request.getEventDate(), show.getGenre());

        // 4. Trigger Challenges
        challengeEvaluator.evaluateUserChallenges(state, request.getEventDate());

        // 5. Trigger Badges (Since points might have just increased!)
        badgeEvaluator.evaluateAndAssignBadges(user);

        log.info("Successfully processed watch activity for User: {}", user.getUserId());
    }

    private UserState recalculateUserState(UserEntity user, LocalDate asOfDate, String currentGenre) {
        UserState state = userStateRepository.findById(user.getUserId())
                .orElse(new UserState());
        state.setUser(user);

        // --- A. TODAY'S METRICS ---
        // Fetch all events for this specific day
        List<ActivityEvent> todaysEvents = activityEventRepository.findByUser_UserIdAndEventDate(user.getUserId(), asOfDate);

        state.setWatchMinutesToday(todaysEvents.stream().mapToInt(ActivityEvent::getWatchMinutes).sum());
        state.setEpisodesCompletedToday(todaysEvents.stream().mapToInt(ActivityEvent::getEpisodesCompleted).sum());
        state.setWatchPartyMinutesToday(todaysEvents.stream().mapToInt(ActivityEvent::getWatchPartyMinutes).sum());
        state.setRatingsToday(todaysEvents.stream().mapToInt(ActivityEvent::getRatings).sum());

        // Simplified unique genres (In a real app, you'd track distinct genres from a junction table, but we'll increment if it's > 0 watch time)
        state.setUniqueGenresToday(state.getUniqueGenresToday() + 1);

        // --- B. 7-DAY METRICS ---
        LocalDate sevenDaysAgo = asOfDate.minusDays(6); // Today + 6 previous days = 7 days
        List<ActivityEvent> sevenDayEvents = activityEventRepository.findByUser_UserIdAndEventDateBetween(user.getUserId(), sevenDaysAgo, asOfDate);

        state.setWatchMinutes7d(sevenDayEvents.stream().mapToInt(ActivityEvent::getWatchMinutes).sum());
        state.setEpisodesCompleted7d(sevenDayEvents.stream().mapToInt(ActivityEvent::getEpisodesCompleted).sum());
        state.setRatings7d(sevenDayEvents.stream().mapToInt(ActivityEvent::getRatings).sum());

        // --- C. STREAK CALCULATION ---
        int streak = calculateStreak(user.getUserId(), asOfDate);
        state.setWatchStreakDays(streak);

        return userStateRepository.save(state);
    }

    private int calculateStreak(String userId, LocalDate asOfDate) {
        int streak = 0;
        LocalDate checkDate = asOfDate;

        // Iterate backwards. If the user watched >= 30 mins on that date, streak ++
        while (true) {
            List<ActivityEvent> eventsOnDate = activityEventRepository.findByUser_UserIdAndEventDate(userId, checkDate);
            int dailyMinutes = eventsOnDate.stream().mapToInt(ActivityEvent::getWatchMinutes).sum();

            if (dailyMinutes >= 30) {
                streak++;
                checkDate = checkDate.minusDays(1); // Check the day before
            } else {
                break; // Streak broken
            }
        }
        return streak;
    }
}