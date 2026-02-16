package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.Episode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EpisodeRepository extends JpaRepository<Episode, String> {
    // Helpful for the dashboard to list episodes of a specific show
    List<Episode> findByShow_ShowId(String showId);
}