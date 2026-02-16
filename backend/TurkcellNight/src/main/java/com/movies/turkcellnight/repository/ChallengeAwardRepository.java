package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.ChallengeAward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChallengeAwardRepository extends JpaRepository<ChallengeAward, Long> {
    List<ChallengeAward> findByUser_UserId(String userId);
}
