package com.snowresorts.resort.application;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.snowresorts.resort.domain.model.Resort;
import com.snowresorts.resort.domain.model.ResortReview;
import com.snowresorts.resort.domain.port.AuthorSummary;
import com.snowresorts.resort.domain.port.ResortReviews;
import com.snowresorts.resort.domain.port.Resorts;
import com.snowresorts.resort.domain.port.ReviewAuthors;
import com.snowresorts.resort.infrastructure.web.ReviewResponse;
import com.snowresorts.security.error.BadRequestException;
import com.snowresorts.security.error.ConflictException;
import com.snowresorts.security.error.ForbiddenException;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class ResortReviewServiceTest {

    private static final UUID RESORT_ID = UUID.fromString("aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa");
    private static final UUID USER_ID = UUID.fromString("bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb");
    private static final UUID OTHER_USER_ID = UUID.fromString("cccccccc-cccc-cccc-cccc-cccccccccccc");
    private static final UUID REVIEW_ID = UUID.fromString("dddddddd-dddd-dddd-dddd-dddddddddddd");

    @Mock
    private ResortReviews reviews;
    @Mock
    private Resorts resorts;
    @Mock
    private ReviewAuthors reviewAuthors;

    private ResortReviewService service;

    @BeforeEach
    void setUp() {
        service = new ResortReviewService(reviews, resorts, reviewAuthors);
    }

    private Resort resort() {
        return new Resort(RESORT_ID, "vail", "Vail", "US", 39.6, -106.3,
                null, null, BigDecimal.ZERO.setScale(2), 0);
    }

    @Test
    @DisplayName("create with a duplicate review by the same user for the same resort throws Conflict")
    void create_secondReviewBySameUser_throwsConflict() {
        // Arrange
        when(resorts.findById(RESORT_ID)).thenReturn(Optional.of(resort()));
        when(reviews.existsByResortIdAndUserId(RESORT_ID, USER_ID)).thenReturn(true);

        // Act + Assert
        assertThatThrownBy(() -> service.create(RESORT_ID, USER_ID, 4, "Great", "Nice", null))
                .isInstanceOf(ConflictException.class);
        verify(reviews, never()).save(any());
        verify(resorts, never()).updateAggregate(any(), any(), eq(0));
    }

    @Test
    @DisplayName("create recomputes the resort aggregate: ratings [4,5] -> avg 4.50, count 2")
    void create_newReview_recomputesAggregate() {
        // Arrange
        when(resorts.findById(RESORT_ID)).thenReturn(Optional.of(resort()));
        when(reviews.existsByResortIdAndUserId(RESORT_ID, USER_ID)).thenReturn(false);
        when(reviews.save(any())).thenAnswer(invocation -> invocation.getArgument(0));
        when(reviews.findRatingsByResortId(RESORT_ID)).thenReturn(List.of(4, 5));
        when(reviewAuthors.resolve(any())).thenReturn(Map.of(
                USER_ID, new AuthorSummary("Rider", "http://cdn/avatar")));

        // Act
        ReviewResponse response = service.create(RESORT_ID, USER_ID, 5, "Epic", "Loved it", null);

        // Assert
        assertThat(response.authorName()).isEqualTo("Rider");
        assertThat(response.authorAvatarUrl()).isEqualTo("http://cdn/avatar");
        verify(reviews).save(any());
        verify(resorts).updateAggregate(RESORT_ID, new BigDecimal("4.50"), 2);
    }

    @Test
    @DisplayName("update by a non-owner throws Forbidden and does not persist changes")
    void update_byNonOwner_throwsForbidden() {
        // Arrange: review belongs to OTHER_USER_ID
        ResortReview othersReview = new ResortReview(REVIEW_ID, RESORT_ID, OTHER_USER_ID, 3,
                "ok", "meh", null, Instant.now());
        when(reviews.findById(REVIEW_ID)).thenReturn(Optional.of(othersReview));

        // Act + Assert
        assertThatThrownBy(() -> service.update(RESORT_ID, REVIEW_ID, USER_ID, 5, "x", "y", null))
                .isInstanceOf(ForbiddenException.class);
        verify(reviews, never()).save(any());
        verify(resorts, never()).updateAggregate(any(), any(), eq(0));
    }

    @Test
    @DisplayName("create with a rating outside 1..5 is rejected by the service guard")
    void create_ratingOutOfRange_throwsBadRequest() {
        when(resorts.findById(RESORT_ID)).thenReturn(Optional.of(resort()));

        assertThatThrownBy(() -> service.create(RESORT_ID, USER_ID, 6, "x", "y", null))
                .isInstanceOf(BadRequestException.class);
        verify(reviews, never()).save(any());
    }

    @Test
    @DisplayName("findMyReview returns the caller's review when one exists")
    void findMyReview_whenPresent_returnsEnrichedReview() {
        ResortReview ownReview = new ResortReview(REVIEW_ID, RESORT_ID, USER_ID, 4,
                "good", "fun", null, Instant.now());
        when(resorts.findById(RESORT_ID)).thenReturn(Optional.of(resort()));
        when(reviews.findByResortIdAndUserId(RESORT_ID, USER_ID)).thenReturn(Optional.of(ownReview));
        when(reviewAuthors.resolve(any())).thenReturn(Map.of(
                USER_ID, new AuthorSummary("Rider", "http://cdn/avatar")));

        var result = service.findMyReview(RESORT_ID, USER_ID);

        assertThat(result).isPresent();
        assertThat(result.get().authorName()).isEqualTo("Rider");
        assertThat(result.get().rating()).isEqualTo(4);
    }

    @Test
    @DisplayName("findMyReview is empty when the caller has not reviewed the resort")
    void findMyReview_whenAbsent_returnsEmpty() {
        when(resorts.findById(RESORT_ID)).thenReturn(Optional.of(resort()));
        when(reviews.findByResortIdAndUserId(RESORT_ID, USER_ID)).thenReturn(Optional.empty());

        assertThat(service.findMyReview(RESORT_ID, USER_ID)).isEmpty();
    }

    @Test
    @DisplayName("delete by the owner removes the review and recomputes the aggregate to zero when empty")
    void delete_byOwner_recomputesAggregate() {
        // Arrange
        ResortReview ownReview = new ResortReview(REVIEW_ID, RESORT_ID, USER_ID, 4,
                "good", "fun", null, Instant.now());
        when(reviews.findById(REVIEW_ID)).thenReturn(Optional.of(ownReview));
        when(reviews.findRatingsByResortId(RESORT_ID)).thenReturn(List.of());

        // Act
        service.delete(RESORT_ID, REVIEW_ID, USER_ID);

        // Assert
        verify(reviews).deleteById(REVIEW_ID);
        verify(resorts).updateAggregate(RESORT_ID, new BigDecimal("0.00"), 0);
    }
}
