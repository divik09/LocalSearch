package com.localsearch.backend.controller;

import com.localsearch.backend.entity.Business;
import com.localsearch.backend.entity.Category;
import com.localsearch.backend.service.SearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "http://localhost:4200") // Allow Angular
@RequiredArgsConstructor
public class SearchController {

    private final SearchService searchService;

    @GetMapping("/categories")
    public List<Category> getCategories() {
        return searchService.getAllCategories();
    }

    @GetMapping("/search")
    public List<Business> search(@RequestParam(required = false) String query,
            @RequestParam(required = false) String city) {
        return searchService.searchBusinesses(query, city);
    }
}
