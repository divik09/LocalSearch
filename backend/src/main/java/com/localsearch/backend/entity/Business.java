package com.localsearch.backend.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Business {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @Column(length = 1000)
    private String description;

    private String contactNumber;
    private String address;
    private String city;

    private Double rating; // 1.0 to 5.0
    private Integer reviewCount;

    // Simple verification status
    private boolean isVerified;

    // Link to category
    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    // Image stored as BLOB
    @Lob
    @Column(name = "image", columnDefinition = "LONGBLOB")
    private byte[] image;

    // Owner of the business (SERVICE_PROVIDER user)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id", nullable = true)
    private User owner;
}
