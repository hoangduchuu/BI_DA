package com.acme.bida;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = "com.acme.bida")
public class BidaApplication {
    public static void main(String[] args) {
        SpringApplication.run(BidaApplication.class, args);
    }
}
