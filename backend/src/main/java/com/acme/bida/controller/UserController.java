package com.acme.bida.controller;

import com.acme.bida.domain.entity.User;
import com.acme.bida.repository.UserRepository;
import com.acme.bida.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@Slf4j
public class UserController {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthService authService;
    
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userRepository.findAll();
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/me")
    public ResponseEntity<User> getCurrentUser() {
        log.info("getCurrentUser endpoint called");
        
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        log.info("Authentication object: {}", authentication);
        
        if (authentication == null || !authentication.isAuthenticated()) {
            log.warn("No valid authentication found");
            return ResponseEntity.status(401).build();
        }
        
        String username = authentication.getName();
        log.info("Username from authentication: {}", username);
        
        Optional<User> user = userRepository.findByUsername(username);
        log.info("User found: {}", user.isPresent());
        
        if (user.isPresent()) {
            log.info("Returning user: {}", user.get().getUsername());
        } else {
            log.warn("User not found for username: {}", username);
        }
        
        return user.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/{username}")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
        Optional<User> user = userRepository.findByUsername(username);
        return user.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping("/create")
    public ResponseEntity<User> createUser(@Valid @RequestBody User user) {
        try {
            // Check if username already exists
            if (userRepository.findByUsername(user.getUsername()).isPresent()) {
                return ResponseEntity.badRequest().build();
            }
            
            // Check if email already exists
            if (userRepository.findByEmail(user.getEmail()).isPresent()) {
                return ResponseEntity.badRequest().build();
            }
            
            // Hash the password properly
            String hashedPassword = passwordEncoder.encode(user.getPasswordHash());
            user.setPasswordHash(hashedPassword);
            
            // Set default values
            if (user.getIsActive() == null) {
                user.setIsActive(true);
            }
            if (user.getRole() == null) {
                user.setRole(User.UserRole.CUSTOMER);
            }
            
            User savedUser = userRepository.save(user);
            return ResponseEntity.ok(savedUser);
        } catch (Exception e) {
            log.error("Error creating user: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @GetMapping("/test/password")
    public ResponseEntity<String> testPassword(@RequestParam String rawPassword, @RequestParam String username) {
        Optional<User> userOpt = userRepository.findByUsername(username);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            boolean matches = passwordEncoder.matches(rawPassword, user.getPasswordHash());
            return ResponseEntity.ok("Password matches for " + username + ": " + matches + 
                                   "\nStored hash: " + user.getPasswordHash());
        }
        return ResponseEntity.notFound().build();
    }
    
    @GetMapping("/test/hash")
    public ResponseEntity<String> testHash(@RequestParam String rawPassword) {
        String hash = passwordEncoder.encode(rawPassword);
        return ResponseEntity.ok("Generated hash for '" + rawPassword + "': " + hash);
    }
}
