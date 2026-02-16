package com.movies.turkcellnight.controller;

import com.movies.turkcellnight.dtos.DailyPointsGraphDto;
import com.movies.turkcellnight.service.LedgerService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ledger")
@RequiredArgsConstructor
public class LedgerController {

    private final LedgerService ledgerService;

    @GetMapping("/users/{userId}/graph")
    public ResponseEntity<List<DailyPointsGraphDto>> getPointsGraph(@PathVariable String userId) {
        List<DailyPointsGraphDto> graphData = ledgerService.getDailyPointsGraph(userId);
        return ResponseEntity.ok(graphData);
    }
}