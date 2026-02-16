package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.ActivityEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ActivityEventRepository extends JpaRepository<ActivityEvent, String> {
    // 1. Get exact day metrics (Today)
    @Query("SELECT a FROM ActivityEvent a WHERE a.user.userId = :userId AND a.eventDate = :asOfDate")
    Optional<ActivityEvent> findByUserIdAndDate(@Param("userId") String userId, @Param("asOfDate") LocalDate asOfDate);

    // 2. Get the last 7 days of activity for aggregations
    @Query("SELECT a FROM ActivityEvent a WHERE a.user.userId = :userId AND a.eventDate > :startDate AND a.eventDate <= :endDate")
    List<ActivityEvent> findLast7Days(@Param("userId") String userId, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    // 3. Get all days where watch_minutes >= 30, ordered backward, to calculate the Streak
    @Query("SELECT a.eventDate FROM ActivityEvent a WHERE a.user.userId = :userId AND a.eventDate <= :asOfDate AND a.watchMinutes >= 30 ORDER BY a.eventDate DESC")
    List<LocalDate> findQualifyingStreakDates(@Param("userId") String userId, @Param("asOfDate") LocalDate asOfDate);

    List<ActivityEvent> findByUser_UserIdAndEventDate(String userId, LocalDate asOfDate);

    List<ActivityEvent> findByUser_UserIdAndEventDateBetween(String userId, LocalDate sevenDaysAgo, LocalDate asOfDate);
}