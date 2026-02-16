package com.movies.turkcellnight.dtos;

import lombok.Data;
import java.time.LocalDate;

@Data
public class WatchRequest {
    private String userId;
    private String episodeId;
    private LocalDate eventDate; // Allows time-travel testing
    private boolean isWatchParty;
    private Integer rating; // 1-5, if the user rated it
}