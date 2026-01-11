package com.localsearch.backend.repository;

import com.localsearch.backend.entity.Business;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BusinessRepository extends JpaRepository<Business, Long> {
    List<Business> findByCity(String city);

    List<Business> findByCategoryId(Long categoryId);

    @Query("SELECT b FROM Business b WHERE b.name LIKE %:query% OR b.description LIKE %:query% OR b.category.name LIKE %:query%")
    List<Business> search(String query);
}
