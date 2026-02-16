package com.movies.turkcellnight.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "challenge_decisions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChallengeDecision {

    @Id
    @Column(name = "decision_id")
    private String decisionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    @Column(name = "as_of_date")
    private LocalDate asOfDate;

    @Column(name = "selected_reward_points")
    private Integer selectedRewardPoints;

    private String reason;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}