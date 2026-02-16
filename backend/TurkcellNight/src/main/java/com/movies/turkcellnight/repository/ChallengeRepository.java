package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.Challenge;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChallengeRepository extends JpaRepository<Challenge, String> {
    List<Challenge> findByIsActiveTrue();
}
