package com.movies.turkcellnight.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "shows")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Show {

    @Id
    @Column(name = "show_id")
    private String showId;

    @Column(name = "show_name", nullable = false)
    private String showName;

    private String genre;
}