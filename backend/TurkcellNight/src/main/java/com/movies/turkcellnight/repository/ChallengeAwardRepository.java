package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.ChallengeAward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChallengeAwardRepository extends JpaRepository<ChallengeAward, Long> {
}
