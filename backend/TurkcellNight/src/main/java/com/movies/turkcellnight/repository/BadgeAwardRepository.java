package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.BadgeAward;
import com.movies.turkcellnight.entity.BadgeAwardId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BadgeAwardRepository extends JpaRepository<BadgeAward, BadgeAwardId> {

    // Finds all badges a specific user has already won
    List<BadgeAward> findByUser_UserId(String userId);
}