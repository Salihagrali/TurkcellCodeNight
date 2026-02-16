package com.movies.turkcellnight.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "badges")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Badge {

    @Id
    @Column(name = "badge_id")
    private String badgeId;

    private String badgeName;
    private String conditionRule; // e.g., "total_points >= 300"
    private Integer level;
}