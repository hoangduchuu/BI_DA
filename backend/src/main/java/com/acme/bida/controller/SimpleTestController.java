package com.acme.bida.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/simple")
public class SimpleTestController {
    
    @GetMapping("/test")
    public String test() {
        return "Simple test endpoint working!";
    }
    
    @GetMapping("/health")
    public String health() {
        return "Simple health check working!";
    }
}
