package com.acme.bida.controller;

import com.acme.bida.domain.entity.User;
import com.acme.bida.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
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
    
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userRepository.findAll();
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/{username}")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
        Optional<User> user = userRepository.findByUsername(username);
        return user.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping("/create")
    public ResponseEntity<User> createUser(@RequestBody User user) {
        // Hash the password
        user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
        user.setPasswordHash(user.getPasswordHash()); // This is the hashed password
        
        User savedUser = userRepository.save(user);
        return ResponseEntity.ok(savedUser);
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
