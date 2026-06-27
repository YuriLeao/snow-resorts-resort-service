package com.snowresorts.resort.application;

import com.snowresorts.resort.domain.model.ResortReview;
import com.snowresorts.resort.domain.port.ResortReviews;
import com.snowresorts.resort.domain.port.Resorts;
import com.snowresorts.resort.infrastructure.web.PageResponse;
import com.snowresorts.resort.infrastructure.web.ReviewResponse;
import com.snowresorts.security.error.BadRequestException;
import com.snowresorts.security.error.ConflictException;
import com.snowresorts.security.error.ForbiddenException;
import com.snowresorts.security.error.ResourceNotFoundException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Write-side use cases for resort reviews. Enforces one review per user per resort, ownership on
 * mutation, and recomputes the cached resort rating aggregate within the same transaction.
 */
@Service
public class ResortReviewService {

    private static final Logger log = LoggerFactory.getLogger(ResortReviewService.class);

    private final ResortReviews reviews;
    private final Resorts resorts;

    public ResortReviewService(ResortReviews reviews, Resorts resorts) {
        this.reviews = reviews;
        this.resorts = resorts;
    }

    @Transactional(readOnly = true)
    public PageResponse<ReviewResponse> listReviews(UUID resortId, Pageable pageable) {
        requireResort(resortId);
        return PageResponse.from(reviews.findByResortId(resortId, pageable).map(ReviewResponse::from));
    }

    @Transactional
    public ReviewResponse create(UUID resortId, UUID userId, int rating, String title, String comment,
                                 LocalDate visitedAt) {
        requireResort(resortId);
        guardRating(rating);
        if (reviews.existsByResortIdAndUserId(resortId, userId)) {
            throw new ConflictException("You have already reviewed this resort.");
        }

        ResortReview saved = reviews.save(new ResortReview(
                UUID.randomUUID(), resortId, userId, rating, title, comment, visitedAt, Instant.now()));
        recomputeAggregate(resortId);
        log.info("Created review {} for resort {} by user {}", saved.id(), resortId, userId);
        return ReviewResponse.from(saved);
    }

    @Transactional
    public ReviewResponse update(UUID resortId, UUID reviewId, UUID userId, int rating, String title,
                                 String comment, LocalDate visitedAt) {
        guardRating(rating);
        ResortReview existing = requireOwnedReview(resortId, reviewId, userId);

        ResortReview updated = reviews.save(new ResortReview(
                existing.id(), resortId, userId, rating, title, comment, visitedAt, existing.createdAt()));
        recomputeAggregate(resortId);
        log.info("Updated review {} for resort {} by user {}", reviewId, resortId, userId);
        return ReviewResponse.from(updated);
    }

    @Transactional
    public void delete(UUID resortId, UUID reviewId, UUID userId) {
        requireOwnedReview(resortId, reviewId, userId);
        reviews.deleteById(reviewId);
        recomputeAggregate(resortId);
        log.info("Deleted review {} for resort {} by user {}", reviewId, resortId, userId);
    }

    private ResortReview requireOwnedReview(UUID resortId, UUID reviewId, UUID userId) {
        ResortReview existing = reviews.findById(reviewId)
                .orElseThrow(() -> ResourceNotFoundException.of("Review", reviewId));
        if (!existing.resortId().equals(resortId)) {
            throw ResourceNotFoundException.of("Review", reviewId);
        }
        if (!existing.userId().equals(userId)) {
            throw new ForbiddenException("You can only modify your own review.");
        }
        return existing;
    }

    private void recomputeAggregate(UUID resortId) {
        List<Integer> ratings = reviews.findRatingsByResortId(resortId);
        int count = ratings.size();
        BigDecimal average = count == 0
                ? BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP)
                : BigDecimal.valueOf(ratings.stream().mapToInt(Integer::intValue).sum())
                        .divide(BigDecimal.valueOf(count), 2, RoundingMode.HALF_UP);
        resorts.updateAggregate(resortId, average, count);
    }

    private void requireResort(UUID resortId) {
        if (resorts.findById(resortId).isEmpty()) {
            throw ResourceNotFoundException.of("Resort", resortId);
        }
    }

    private void guardRating(int rating) {
        if (rating < 1 || rating > 5) {
            throw new BadRequestException("rating must be between 1 and 5.");
        }
    }
}
