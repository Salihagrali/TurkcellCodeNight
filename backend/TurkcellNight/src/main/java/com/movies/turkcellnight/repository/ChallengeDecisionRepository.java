package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.ChallengeDecision;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChallengeDecisionRepository extends JpaRepository<ChallengeDecision, String> {
}