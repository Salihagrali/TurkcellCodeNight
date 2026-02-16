package com.movies.turkcellnight.controller;

import com.movies.turkcellnight.dtos.EpisodeDto;
import com.movies.turkcellnight.dtos.ShowWithEpisodesDto;
import com.movies.turkcellnight.entity.Episode;
import com.movies.turkcellnight.entity.Show;
import com.movies.turkcellnight.repository.EpisodeRepository;
import com.movies.turkcellnight.repository.ShowRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/catalog")
@RequiredArgsConstructor
public class ContentController {
    private final ShowRepository showRepository;
    private final EpisodeRepository episodeRepository;

    // GET SHOWS WITH THEIR EPISODES NESTED
    @GetMapping("/shows-with-episodes")
    public ResponseEntity<List<ShowWithEpisodesDto>> getShowsWithEpisodes() {

        // 1. Fetch all shows and all episodes (Only 2 DB queries!)
        List<Show> allShows = showRepository.findAll();
        List<Episode> allEpisodes = episodeRepository.findAll();

        // 2. Group all episodes by their Show ID using Java Streams
        Map<String, List<Episode>> episodesByShowId = allEpisodes.stream()
                .collect(Collectors.groupingBy(episode -> episode.getShow().getShowId()));

        // 3. Map the Shows to the new DTO, attaching the grouped episodes
        List<ShowWithEpisodesDto> response = allShows.stream()
                .map(show -> {
                    // Get the episodes for this specific show, or an empty list if none exist
                    List<Episode> showEpisodes = episodesByShowId.getOrDefault(show.getShowId(), List.of());

                    // Convert the Episode entities to EpisodeDtos
                    List<EpisodeDto> episodeDtos = showEpisodes.stream()
                            .map(this::mapToEpisodeDto) // using the helper method we made earlier
                            .collect(Collectors.toList());

                    // Build the final nested DTO
                    return ShowWithEpisodesDto.builder()
                            .showId(show.getShowId())
                            .showName(show.getShowName())
                            .genre(show.getGenre())
                            .episodes(episodeDtos)
                            .build();
                })
                .collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    // Helper method to map Entity to DTO safely
    private EpisodeDto mapToEpisodeDto(Episode episode) {
        return EpisodeDto.builder()
                .episodeId(episode.getEpisodeId())
                .showId(episode.getShow().getShowId())
                .showName(episode.getShow().getShowName())
                .season(episode.getSeason())
                .episodeNo(episode.getEpisodeNo())
                .durationMin(episode.getDurationMin())
                .build();
    }
}
