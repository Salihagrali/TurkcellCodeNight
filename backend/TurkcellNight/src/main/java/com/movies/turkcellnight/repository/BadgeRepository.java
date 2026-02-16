package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.Badge;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BadgeRepository extends JpaRepository<Badge, String> {
}