package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.UserState;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserStateRepository extends JpaRepository<UserState, String> {
}
