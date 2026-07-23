package com.snowresorts.resort.infrastructure.user;

import com.snowresorts.resort.application.UserServiceProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class UserServiceClientConfig {

    @Bean
    RestClient userServiceRestClient(RestClient.Builder restClientBuilder, UserServiceProperties properties) {
        return restClientBuilder
                .baseUrl(properties.baseUrl())
                .build();
    }
}
