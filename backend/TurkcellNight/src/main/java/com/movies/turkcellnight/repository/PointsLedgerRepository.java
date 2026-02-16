package com.movies.turkcellnight.repository;

import com.movies.turkcellnight.entity.PointsLedger;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PointsLedgerRepository extends JpaRepository<PointsLedger,String> {
    List<PointsLedger> findByUser_UserIdOrderByCreatedAtAsc(String userId);
}
