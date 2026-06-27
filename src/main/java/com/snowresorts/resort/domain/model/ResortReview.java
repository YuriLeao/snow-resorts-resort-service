package com.snowresorts.resort.domain.model;

import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

/** A user's review of a resort. One review per user per resort is enforced at the data layer. */
public record ResortReview(
        UUID id,
        UUID resortId,
        UUID userId,
        int rating,
        String title,
        String comment,
        LocalDate visitedAt,
        Instant createdAt) {
}
