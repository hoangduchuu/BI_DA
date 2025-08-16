package com.acme.bida.controller;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {
    
    private final PasswordEncoder passwordEncoder;
    
    public TestController(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }
    
    @GetMapping("/test/hash")
    public String testHash(@RequestParam String password) {
        return passwordEncoder.encode(password);
    }
    
    @GetMapping("/test/match")
    public String testMatch(@RequestParam String rawPassword, @RequestParam String encodedPassword) {
        boolean matches = passwordEncoder.matches(rawPassword, encodedPassword);
        return "Password matches: " + matches;
    }
}
