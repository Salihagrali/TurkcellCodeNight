package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, String> {

    // Optional: Useful for your Flutter dashboard to fetch a user's notification history!
    List<Notification> findByUser_UserIdOrderBySentAtDesc(String userId);
}