package com.movies.turkcellnight.dtos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
public class ShowWithEpisodesDto {
    private String showId;
    private String showName;
    private String genre;
    private List<EpisodeDto> episodes; // The nested list!
}