package com.movies.turkcellnight.dtos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class EpisodeDto {
    private String episodeId;
    private String showId;
    private String showName;
    private int season;
    private int episodeNo;
    private int durationMin;
}