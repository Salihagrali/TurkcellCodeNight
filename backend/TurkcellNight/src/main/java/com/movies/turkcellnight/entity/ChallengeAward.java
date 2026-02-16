package com.movies.turkcellnight.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Set;

@Entity
@Table(name = "challenge_awards")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChallengeAward {
    @Id
    @Column(name = "award_id")
    private String awardId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private UserEntity user;

    private LocalDate asOfDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "selected_challenge_id")
    private Challenge selectedChallenge;

    private Integer rewardPoints;
    private LocalDateTime createdAt;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "award_suppressed_challenges",
            joinColumns = @JoinColumn(name = "award_id"),
            inverseJoinColumns = @JoinColumn(name = "challenge_id")
    )
    private Set<Challenge> suppressedChallenges;
}