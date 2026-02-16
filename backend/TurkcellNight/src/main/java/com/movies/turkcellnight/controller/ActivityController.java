package com.movies.turkcellnight.controller;

import com.movies.turkcellnight.dtos.WatchRequest;
import com.movies.turkcellnight.service.ActivityService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/activity")
@RequiredArgsConstructor
public class ActivityController {

    private final ActivityService activityService;

    @PostMapping("/watch")
    public ResponseEntity<String> recordWatch(@RequestBody WatchRequest request) {
        try {
            activityService.processWatchActivity(request);
            return ResponseEntity.ok("İzleme kaydedildi. Metrikler güncellendi, Challenge ve Rozetler kontrol edildi!");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Hata: " + e.getMessage());
        }
    }
}