package com.movies.turkcellnight.entity;

import com.movies.turkcellnight.utils.ChallengeType;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "challenges")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Challenge {
    @Id
    @Column(name = "challenge_id")
    private String challengeId;
    private String challengeName;
    @Enumerated(EnumType.STRING)
    private ChallengeType challengeType; // Enum: DAILY, WEEKLY, STREAK
    private String conditionRule;
    private Integer rewardPoints;
    private Integer priority;
    private Boolean isActive;
}