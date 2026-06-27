package com.snowresorts.resort.application;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import com.snowresorts.resort.domain.model.Difficulty;
import com.snowresorts.resort.domain.model.Lift;
import com.snowresorts.resort.domain.model.Resort;
import com.snowresorts.resort.domain.model.Trail;
import com.snowresorts.resort.domain.port.Lifts;
import com.snowresorts.resort.domain.port.Resorts;
import com.snowresorts.resort.domain.port.Trails;
import com.snowresorts.resort.infrastructure.web.ResortDetail;
import com.snowresorts.security.error.ResourceNotFoundException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class ResortQueryServiceTest {

    private static final UUID RESORT_ID = UUID.fromString("aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa");

    @Mock
    private Resorts resorts;
    @Mock
    private Trails trails;
    @Mock
    private Lifts lifts;

    private ResortQueryService service;

    @BeforeEach
    void setUp() {
        service = new ResortQueryService(resorts, trails, lifts);
    }

    @Test
    @DisplayName("detail of an unknown id throws ResourceNotFoundException")
    void detail_unknownId_throwsResourceNotFound() {
        when(resorts.findById(RESORT_ID)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.detail(RESORT_ID))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("detail maps the resort, trails and lifts into the detail DTO correctly")
    void detail_existingResort_mapsToDetailDto() {
        // Arrange
        Resort resort = new Resort(RESORT_ID, "vail", "Vail", "US", 39.6, -106.3,
                "https://vail.com", "Big mountain", new BigDecimal("4.50"), 2);
        Trail trail = new Trail(UUID.randomUUID(), RESORT_ID, "Riva Ridge", Difficulty.BLACK,
                List.of(new double[] {-106.3, 39.6}, new double[] {-106.31, 39.61}));
        Lift lift = new Lift(UUID.randomUUID(), RESORT_ID, "Gondola One",
                List.of(new double[] {-106.30, 39.60}, new double[] {-106.32, 39.62}));
        when(resorts.findById(RESORT_ID)).thenReturn(Optional.of(resort));
        when(trails.findByResortId(RESORT_ID)).thenReturn(List.of(trail));
        when(lifts.findByResortId(RESORT_ID)).thenReturn(List.of(lift));

        // Act
        ResortDetail detail = service.detail(RESORT_ID);

        // Assert
        assertThat(detail.id()).isEqualTo(RESORT_ID);
        assertThat(detail.name()).isEqualTo("Vail");
        assertThat(detail.officialUrl()).isEqualTo("https://vail.com");
        assertThat(detail.avgRating()).isEqualByComparingTo("4.50");
        assertThat(detail.reviewCount()).isEqualTo(2);
        assertThat(detail.trails()).hasSize(1);
        assertThat(detail.trails().get(0).difficulty()).isEqualTo("black");
        assertThat(detail.trails().get(0).coordinates()).hasSize(2);
        assertThat(detail.lifts()).hasSize(1);
        assertThat(detail.lifts().get(0).name()).isEqualTo("Gondola One");
    }
}
