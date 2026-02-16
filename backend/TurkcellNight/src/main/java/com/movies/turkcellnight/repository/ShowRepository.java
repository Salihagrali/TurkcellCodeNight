package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.Show;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ShowRepository extends JpaRepository<Show, String> {
}