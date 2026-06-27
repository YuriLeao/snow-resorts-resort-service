package com.snowresorts.resort.infrastructure.web;

import com.snowresorts.resort.domain.model.ResortReview;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

/** A resort review as returned to clients. */
public record ReviewResponse(
        UUID id,
        UUID resortId,
        UUID userId,
        int rating,
        String title,
        String comment,
        LocalDate visitedAt,
        Instant createdAt) {

    public static ReviewResponse from(ResortReview review) {
        return new ReviewResponse(
                review.id(),
                review.resortId(),
                review.userId(),
                review.rating(),
                review.title(),
                review.comment(),
                review.visitedAt(),
                review.createdAt());
    }
}
