package com.movies.turkcellnight.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DailyPointsGraphDto {
    private String date;         // X Ekseni (Tarih: "2026-03-10")
    private int dailyEarned;     // O gün kazanılan net puan (Bar Chart için)
    private int totalPoints;     // O günkü kümülatif toplam puan (Line Chart için)
}