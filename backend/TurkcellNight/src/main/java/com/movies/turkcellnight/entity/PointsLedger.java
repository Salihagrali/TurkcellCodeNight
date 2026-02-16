package com.movies.turkcellnight.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "points_ledger")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder()
public class PointsLedger {
    @Id
    @Column(name = "ledger_id")
    private String ledgerId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private UserEntity user;

    private Integer pointsDelta;
    private String source;
    private String sourceRef;
    private LocalDateTime createdAt;
}