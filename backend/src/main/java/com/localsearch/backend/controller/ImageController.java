package com.localsearch.backend.controller;

import com.localsearch.backend.entity.Business;
import com.localsearch.backend.repository.BusinessRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/images")
@CrossOrigin(origins = "http://localhost:4200")
public class ImageController {

    @Autowired
    private BusinessRepository businessRepository;

    @GetMapping("/{businessId}")
    public ResponseEntity<byte[]> getBusinessImage(@PathVariable Long businessId) {
        Optional<Business> businessOpt = businessRepository.findById(businessId);

        if (businessOpt.isPresent() && businessOpt.get().getImage() != null) {
            byte[] image = businessOpt.get().getImage();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            headers.setContentLength(image.length);
            return new ResponseEntity<>(image, headers, HttpStatus.OK);
        }

        return ResponseEntity.notFound().build();
    }
}
