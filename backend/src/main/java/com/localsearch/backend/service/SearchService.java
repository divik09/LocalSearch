package com.localsearch.backend.service;

import com.localsearch.backend.entity.Business;
import com.localsearch.backend.entity.Category;
import com.localsearch.backend.entity.User;
import com.localsearch.backend.enums.Role;
import com.localsearch.backend.repository.BusinessRepository;
import com.localsearch.backend.repository.CategoryRepository;
import com.localsearch.backend.repository.UserRepository;
import com.localsearch.backend.util.ImageUtil;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SearchService {

    private final BusinessRepository businessRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    public List<Business> searchBusinesses(String query, String city) {
        // Simple search logic for now
        if (query == null || query.isBlank()) {
            return businessRepository.findAll();
        }
        return businessRepository.search(query);
    }

    // Seed Data for Demo
    @PostConstruct
    public void seedData() {
        // Create default admin user if not exists
        if (userRepository.count() == 0) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setEmail("admin@localsearch.com");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRole(Role.SUPER_ADMIN);
            admin.setEnabled(true);
            userRepository.save(admin);
            System.out.println("✅ Default admin user created - username: admin, password: admin123");
        }

        if (categoryRepository.count() == 0) {
            // Create Categories
            Category restaurant = new Category();
            restaurant.setName("Restaurants");
            restaurant.setIconUrl("restaurant");
            categoryRepository.save(restaurant);

            Category services = new Category();
            services.setName("Services");
            services.setIconUrl("build");
            categoryRepository.save(services);

            Category homeServices = new Category();
            homeServices.setName("Home Services");
            homeServices.setIconUrl("home_repair_service");
            categoryRepository.save(homeServices);

            // Restaurants
            Business b1 = new Business();
            b1.setName("Spicy Bites");
            b1.setCategory(restaurant);
            b1.setCity("Indore");
            b1.setAddress("123 Sarafa Bazaar, MG Road");
            b1.setContactNumber("+91 98765 43210");
            b1.setRating(4.5);
            b1.setReviewCount(120);
            b1.setVerified(true);
            b1.setDescription("Best spicy food in town. Authentic Indian cuisine with mind-blowing flavors.");
            b1.setImage(ImageUtil.getRestaurantImage());
            businessRepository.save(b1);

            Business b2 = new Business();
            b2.setName("The Italian Corner");
            b2.setCategory(restaurant);
            b2.setCity("Bhopal");
            b2.setAddress("45 New Market, MP Nagar");
            b2.setContactNumber("+91 98765 43211");
            b2.setRating(4.7);
            b2.setReviewCount(95);
            b2.setVerified(true);
            b2.setDescription("Authentic Italian pizzas and pastas. Wood-fired oven specialties.");
            b2.setImage(ImageUtil.getRestaurantImage());
            businessRepository.save(b2);

            // Plumbers
            Business b3 = new Business();
            b3.setName("Quick Fix Plumbing");
            b3.setCategory(homeServices);
            b3.setCity("Indore");
            b3.setAddress("12 Vijay Nagar, AB Road");
            b3.setContactNumber("+91 98765 43212");
            b3.setRating(4.8);
            b3.setReviewCount(200);
            b3.setVerified(true);
            b3.setDescription(
                    "Expert plumber for leak repairs, pipe fitting, bathroom installations. 24/7 emergency service available.");
            b3.setImage(ImageUtil.getPlumberImage());
            businessRepository.save(b3);

            Business b4 = new Business();
            b4.setName("Jabalpur Plumbing Solutions");
            b4.setCategory(homeServices);
            b4.setCity("Jabalpur");
            b4.setAddress("78 Wright Town, Napier Town");
            b4.setContactNumber("+91 98765 43213");
            b4.setRating(4.6);
            b4.setReviewCount(150);
            b4.setVerified(true);
            b4.setDescription("Professional plumbing services. Drain cleaning, water heater installation, and more.");
            b4.setImage(ImageUtil.getPlumberImage());
            businessRepository.save(b4);

            // Electricians
            Business b5 = new Business();
            b5.setName("Bright Spark Electricians");
            b5.setCategory(homeServices);
            b5.setCity("Bhopal");
            b5.setAddress("34 Arera Colony, Zone 1");
            b5.setContactNumber("+91 98765 43214");
            b5.setRating(4.9);
            b5.setReviewCount(180);
            b5.setVerified(true);
            b5.setDescription("Licensed electrician for wiring, repairs, installations. Fast and reliable service.");
            b5.setImage(ImageUtil.getElectricianImage());
            businessRepository.save(b5);

            Business b6 = new Business();
            b6.setName("Power Solutions Electric");
            b6.setCategory(homeServices);
            b6.setCity("Indore");
            b6.setAddress("56 Palasia Square, Treasure Island");
            b6.setContactNumber("+91 98765 43215");
            b6.setRating(4.7);
            b6.setReviewCount(145);
            b6.setVerified(true);
            b6.setDescription("Expert electrician services. Panel upgrades, lighting installation, emergency repairs.");
            b6.setImage(ImageUtil.getElectricianImage());
            businessRepository.save(b6);

            Business b7 = new Business();
            b7.setName("City Electric Works");
            b7.setCategory(homeServices);
            b7.setCity("Jabalpur");
            b7.setAddress("89 Civic Center, Russell Chowk");
            b7.setContactNumber("+91 98765 43216");
            b7.setRating(4.5);
            b7.setReviewCount(110);
            b7.setVerified(false);
            b7.setDescription("Affordable electrician for home and office. All types of electrical work.");
            b7.setImage(ImageUtil.getElectricianImage());
            businessRepository.save(b7);

            // Cleaners/Sweepers
            Business b8 = new Business();
            b8.setName("Spotless Cleaning Services");
            b8.setCategory(homeServices);
            b8.setCity("Bhopal");
            b8.setAddress("23 Koh-e-Fiza, Bhopal");
            b8.setContactNumber("+91 98765 43217");
            b8.setRating(4.6);
            b8.setReviewCount(95);
            b8.setVerified(true);
            b8.setDescription(
                    "Professional cleaning and sweeping services. Deep cleaning, regular maintenance, move-in/out cleaning.");
            b8.setImage(ImageUtil.getCleaningImage());
            businessRepository.save(b8);

            Business b9 = new Business();
            b9.setName("Clean Pro Services");
            b9.setCategory(homeServices);
            b9.setCity("Indore");
            b9.setAddress("67 South Tukoganj, Indore");
            b9.setContactNumber("+91 98765 43218");
            b9.setRating(4.4);
            b9.setReviewCount(78);
            b9.setVerified(true);
            b9.setDescription("Expert sweeper and cleaning staff. Daily, weekly, or monthly plans available.");
            b9.setImage(ImageUtil.getCleaningImage());
            businessRepository.save(b9);

            // General Services
            Business b10 = new Business();
            b10.setName("AC Cool Care");
            b10.setCategory(services);
            b10.setCity("Jabalpur");
            b10.setAddress("45 Madan Mahal, Jabalpur");
            b10.setContactNumber("+91 98765 43219");
            b10.setRating(4.8);
            b10.setReviewCount(165);
            b10.setVerified(true);
            b10.setDescription("AC repair, servicing, and installation. All brands supported.");
            b10.setImage(ImageUtil.getServiceImage());
            businessRepository.save(b10);

            Business b11 = new Business();
            b11.setName("Handyman Plus");
            b11.setCategory(services);
            b11.setCity("Indore");
            b11.setAddress("90 Rau, Ring Road");
            b11.setContactNumber("+91 98765 43220");
            b11.setRating(4.5);
            b11.setReviewCount(88);
            b11.setVerified(false);
            b11.setDescription(
                    "All-in-one handyman service. Carpentry, painting, furniture assembly, and minor repairs.");
            b11.setImage(ImageUtil.getServiceImage());
            businessRepository.save(b11);
        }
    }
}
