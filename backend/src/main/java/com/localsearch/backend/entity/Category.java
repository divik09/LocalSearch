package com.localsearch.backend.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String iconUrl; // URL or material icon name

    // For hierarchy (optional now, but good for "Restaurants -> Italian")
    @Column(name = "parent_id")
    private Long parentId;
}
