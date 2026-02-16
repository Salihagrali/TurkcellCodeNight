package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, String> {

    // Generates the leaderboard dynamically sorted by points descending, then ID ascending
    @Query("SELECT u FROM UserEntity u ORDER BY u.totalPoints DESC, u.userId ASC")
    List<UserEntity> getLeaderboard();
}
