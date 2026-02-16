package com.movies.turkcellnight.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.util.Set;

@Entity
@Table(name = "activity_events")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ActivityEvent {

    @Id
    @Column(name = "event_id")
    private String eventId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    @Column(name = "event_date", nullable = false)
    private LocalDate eventDate;

    private Integer uniqueGenres;
    private Integer watchMinutes;
    private Integer episodesCompleted;
    private Integer watchPartyMinutes;
    private Integer ratings;

    // This handles the "S1|S3" normalization automatically!
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "activity_shows",
            joinColumns = @JoinColumn(name = "event_id"),
            inverseJoinColumns = @JoinColumn(name = "show_id")
    )
    private Set<Show> showsWatched;
}