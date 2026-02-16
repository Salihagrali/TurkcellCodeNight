package com.movies.turkcellnight.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "user_states")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserState {

    @Id
    @Column(name = "user_id")
    private String userId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "user_id", insertable = false, updatable = false)
    private UserEntity user;

    private Integer watchMinutesToday;
    private Integer episodesCompletedToday;
    private Integer uniqueGenresToday;
    private Integer watchPartyMinutesToday;
    private Integer ratingsToday;

    private Integer watchMinutes7d;
    private Integer episodesCompleted7d;
    private Integer ratings7d;

    private Integer watchStreakDays;
}