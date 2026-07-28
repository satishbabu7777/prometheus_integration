package com.ecommerce.booking.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI orderServiceOpenAPI() {

        return new OpenAPI()
                .info(new Info()
                        .title("Order Service API")
                        .description("REST APIs for Order Service")
                        .version("1.0")
                        .contact(new Contact()
                                .name("Satish")
                                .email("satish@example.com")));
    }
}