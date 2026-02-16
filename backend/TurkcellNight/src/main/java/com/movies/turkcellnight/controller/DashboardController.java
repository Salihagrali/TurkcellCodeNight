package com.movies.turkcellnight.controller;

import com.movies.turkcellnight.dto.UserDashboardDTO;
import com.movies.turkcellnight.entity.UserEntity;
import com.movies.turkcellnight.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/dashboard")
@CrossOrigin(origins = "*") // Web arayüzünden (React/Vue/Flutter Web) gelecek CORS isteklerine izin vermek için
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    /**
     * 1. Kullanıcı listesi ve total_points
     * GET /api/v1/dashboard/users
     */
    @GetMapping("/users")
    public ResponseEntity<List<UserEntity>> getUserList() {
        return ResponseEntity.ok(dashboardService.getAllUsersWithPoints());
    }

    /**
     * 2. Leaderboard
     * GET /api/v1/dashboard/leaderboard
     */
    @GetMapping("/leaderboard")
    public ResponseEntity<List<UserEntity>> getLeaderboard() {
        return ResponseEntity.ok(dashboardService.getLeaderboard());
    }

    /**
     * 3. Kullanıcı Detayı (Tüm Metrikler, Rozetler, Bildirimler, Challenge Kayıtları)
     * GET /api/v1/dashboard/users/{userId}
     */
    @GetMapping("/users/{userId}")
    public ResponseEntity<UserDashboardDTO> getUserDetail(@PathVariable String userId) {
        UserDashboardDTO detail = dashboardService.getUserDashboardDetail(userId);
        return ResponseEntity.ok(detail);
    }
}