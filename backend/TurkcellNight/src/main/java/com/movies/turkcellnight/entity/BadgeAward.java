package com.movies.turkcellnight.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "badge_awards")
@IdClass(BadgeAwardId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BadgeAward {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private UserEntity user;

    @Id
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "badge_id")
    private Badge badge;

    @Column(name = "awarded_at")
    private LocalDateTime awardedAt;
}