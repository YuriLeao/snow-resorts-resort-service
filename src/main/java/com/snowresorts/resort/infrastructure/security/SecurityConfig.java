package com.snowresorts.resort.infrastructure.security;

import com.snowresorts.security.jwt.AccessTokenRevocationStore;
import com.snowresorts.security.jwt.JwtAuthoritiesConverter;
import com.snowresorts.security.jwt.ResourceServerHttpSecurity;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Resort-service security. Every business endpoint requires a valid JWT bearer token.
 * Only actuator health/info, OpenAPI docs and similar infra paths are anonymous.
 *
 * <p>Declaring this {@link SecurityFilterChain} bean disables the shared default chain from
 * {@code security-lib}. Token validation uses Spring Boot's auto-configured {@code JwtDecoder}
 * driven by {@code spring.security.oauth2.resourceserver.jwt.jwk-set-uri}.
 */
@Configuration(proxyBeanMethods = false)
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    SecurityFilterChain resortFilterChain(HttpSecurity http,
                                          AccessTokenRevocationStore accessTokenRevocationStore) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/actuator/health/**",
                                "/actuator/health",
                                "/actuator/info",
                                "/v3/api-docs/**",
                                "/swagger-ui/**",
                                "/swagger-ui.html").permitAll()
                        .anyRequest().authenticated())
                .oauth2ResourceServer(oauth -> oauth.jwt(jwt -> jwt.jwtAuthenticationConverter(
                        new JwtAuthoritiesConverter("roles", "ROLE_"))));
        ResourceServerHttpSecurity.addAccessTokenRevocationFilter(http, accessTokenRevocationStore);
        return http.build();
    }
}
