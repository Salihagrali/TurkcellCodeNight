package com.movies.turkcellnight.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserEntity {

    @Id
    @Column(name = "user_id")
    private String userId;

    private String name;
    private String city;
    private String segment;

    @Column(name = "total_points", columnDefinition = "INT DEFAULT 0")
    private Integer totalPoints;
}