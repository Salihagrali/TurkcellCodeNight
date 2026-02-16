package com.movies.turkcellnight.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "episodes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Episode {

    @Id
    @Column(name = "episode_id")
    private String episodeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "show_id", nullable = false)
    private Show show;

    private Integer season;

    @Column(name = "episode_no")
    private Integer episodeNo;

    @Column(name = "duration_min")
    private Integer durationMin;
}