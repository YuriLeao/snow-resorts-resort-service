package com.snowresorts.resort;

import static org.hamcrest.Matchers.hasItem;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

/**
 * Integration test covering JWT-protected resort endpoints against a real PostGIS database.
 * Compiled in CI but only executed where Docker is available ({@code -DskipITs} skips it).
 * Uses {@code imresamu/postgis:16-3.4} as a drop-in {@code postgres} substitute.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Testcontainers
class ResortServiceIT {

    @Container
    static final PostgreSQLContainer<?> POSTGRES = new PostgreSQLContainer<>(
            DockerImageName.parse("imresamu/postgis:16-3.4").asCompatibleSubstituteFor("postgres"))
            .withDatabaseName("snow_resorts")
            .withUsername("snow")
            .withPassword("snow");

    @DynamicPropertySource
    static void datasourceProperties(DynamicPropertyRegistry registry) {
        // Mirror local dev: currentSchema=resorts requires public in search_path for PostGIS.
        registry.add("spring.datasource.url",
                () -> POSTGRES.getJdbcUrl() + "?currentSchema=resorts");
        registry.add("spring.datasource.username", POSTGRES::getUsername);
        registry.add("spring.datasource.password", POSTGRES::getPassword);
        // No live auth-service in tests: any non-resolvable JWKS URI is fine since we mock jwt().
        registry.add("spring.security.oauth2.resourceserver.jwt.jwk-set-uri",
                () -> "http://localhost:8081/.well-known/jwks.json");
    }

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final UUID resortId = UUID.fromString("11111111-2222-3333-4444-555555555555");
    private final UUID valleNevadoId = UUID.fromString("22222222-3333-4444-5555-666666666666");
    private final UUID userId = UUID.fromString("99999999-8888-7777-6666-555555555555");

    @BeforeEach
    void seedResort() {
        jdbcTemplate.update("DELETE FROM resorts.resort_reviews");
        jdbcTemplate.update("DELETE FROM resorts.resorts");
        jdbcTemplate.update("""
                INSERT INTO resorts.resorts (id, slug, name, country, lat, lng, avg_rating, review_count)
                VALUES (?, 'vail', 'Vail', 'US', 39.6, -106.3, 0, 0)
                """, resortId);
        jdbcTemplate.update("""
                INSERT INTO resorts.resorts (id, slug, name, country, lat, lng, avg_rating, review_count)
                VALUES (?, 'valle-nevado', 'Valle Nevado', 'CL', -33.3556, -70.2486, 0, 0)
                """, valleNevadoId);
    }

    @Test
    @DisplayName("GET /snow-resort-service/v1/resorts without authentication returns 401")
    void listResorts_withoutAuth_returns401() throws Exception {
        mockMvc.perform(get("/snow-resort-service/v1/resorts"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("GET /snow-resort-service/v1/resorts with a valid JWT returns 200")
    void listResorts_withJwt_returns200() throws Exception {
        mockMvc.perform(get("/snow-resort-service/v1/resorts")
                        .with(jwt().jwt(jwt -> jwt.subject(userId.toString()))))
                .andExpect(status().isOk());
    }

    @Test
    @DisplayName("GET /snow-resort-service/v1/resorts?q=valle with JWT returns Valle Nevado")
    void listResorts_withSearchQ_returnsValleNevado() throws Exception {
        mockMvc.perform(get("/snow-resort-service/v1/resorts")
                        .param("q", "valle")
                        .with(jwt().jwt(jwt -> jwt.subject(userId.toString()))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[*].slug", hasItem("valle-nevado")));
    }

    @Test
    @DisplayName("GET /snow-resort-service/v1/resorts/{id}/nearby-geometry returns red intermediate pistes within radius")
    void nearbyGeometry_withJwt_returnsTrailsWithinRadius() throws Exception {
        // A real "Sol 2" intermediate run (mapped to red) near Valle Nevado.
        jdbcTemplate.update("""
                INSERT INTO resorts.trails (id, resort_id, name, difficulty, geom)
                VALUES (gen_random_uuid(), ?, 'Sol 2', 'red',
                        ST_GeomFromText('LINESTRING(-70.2552 -33.3482, -70.2540 -33.3490)', 4326))
                """, valleNevadoId);
        jdbcTemplate.update("""
                INSERT INTO resorts.lifts (id, resort_id, name, geom)
                VALUES (gen_random_uuid(), ?, 'Andes Express',
                        ST_GeomFromText('LINESTRING(-70.2530 -33.3500, -70.2545 -33.3470)', 4326))
                """, valleNevadoId);

        mockMvc.perform(get("/snow-resort-service/v1/resorts/{id}/nearby-geometry", valleNevadoId)
                        .param("radiusKm", "10")
                        .with(jwt().jwt(jwt -> jwt.subject(userId.toString()))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.trails[*].name", hasItem("Sol 2")))
                .andExpect(jsonPath("$.trails[*].difficulty", hasItem("red")))
                .andExpect(jsonPath("$.lifts[*].name", hasItem("Andes Express")));
    }

    @Test
    @DisplayName("GET /snow-resort-service/v1/resorts/{id}/nearby-geometry without authentication returns 401")
    void nearbyGeometry_withoutAuth_returns401() throws Exception {
        mockMvc.perform(get("/snow-resort-service/v1/resorts/{id}/nearby-geometry", valleNevadoId))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("POST /snow-resort-service/v1/resorts/{id}/reviews without authentication returns 401")
    void createReview_withoutAuth_returns401() throws Exception {
        mockMvc.perform(post("/snow-resort-service/v1/resorts/{id}/reviews", resortId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"rating":5,"title":"Epic","comment":"Loved it"}"""))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("POST /snow-resort-service/v1/resorts/{id}/reviews with a valid JWT creates the review (201)")
    void createReview_withJwt_returns201() throws Exception {
        mockMvc.perform(post("/snow-resort-service/v1/resorts/{id}/reviews", resortId)
                        .with(jwt().jwt(jwt -> jwt.subject(userId.toString())))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"rating":5,"title":"Epic","comment":"Loved it"}"""))
                .andExpect(status().isCreated());
    }
}
