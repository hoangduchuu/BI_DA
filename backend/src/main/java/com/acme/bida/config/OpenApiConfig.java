package com.acme.bida.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Billiard Club Management API")
                        .description("""
                                Comprehensive API for managing billiard clubs, tables, bookings, orders, and billing.
                                
                                ## Features
                                - **Multi-tenant Architecture**: Support for multiple companies and clubs
                                - **User Management**: Role-based access control (ADMIN, CLUB_MANAGER, STAFF, CUSTOMER)
                                - **Table Management**: Pool tables, snooker, carom with real-time status
                                - **Booking System**: Table reservations with time slots
                                - **Order Management**: Food, beverages, and services ordering
                                - **Billing System**: Integrated billing with multiple payment methods
                                - **JWT Authentication**: Secure token-based authentication
                                
                                ## Authentication
                                All protected endpoints require a valid JWT token in the Authorization header:
                                ```
                                Authorization: Bearer <your-jwt-token>
                                ```
                                
                                ## Multi-tenancy
                                The system supports multi-tenancy through company_id and club_id fields.
                                Users are associated with specific companies and clubs based on their role.
                                
                                ## Rate Limiting
                                API endpoints are rate-limited to ensure fair usage.
                                """)
                        .version("1.0.0")
                        .contact(new Contact()
                                .name("ACME Bida Team")
                                .email("support@acme-bida.com")
                                .url("https://acme-bida.com"))
                        .license(new License()
                                .name("MIT")
                                .url("https://opensource.org/licenses/MIT")))
                .servers(List.of(
                        new Server()
                                .url("http://localhost:8080/api/v1")
                                .description("Development server"),
                        new Server()
                                .url("https://api.acme-bida.com/api/v1")
                                .description("Production server")))
                .addSecurityItem(new SecurityRequirement().addList("BearerAuth"))
                .components(new io.swagger.v3.oas.models.Components()
                        .addSecuritySchemes("BearerAuth", new SecurityScheme()
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")
                                .description("JWT token obtained from /auth/login endpoint")));
    }
}
