package com.movies.turkcellnight.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BadgeAwardId implements Serializable {
    private String user; // Matches the field name in BadgeAward
    private String badge; // Matches the field name in BadgeAward
}