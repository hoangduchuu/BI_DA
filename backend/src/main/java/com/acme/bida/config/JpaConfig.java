package com.acme.bida.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@Configuration
@EnableJpaAuditing
public class JpaConfig {
    // JPA auditing is enabled for @CreatedDate and @LastModifiedDate annotations
}
