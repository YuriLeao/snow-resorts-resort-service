package com.snowresorts.resort.infrastructure.web;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;

/** Payload to create a resort review. */
public record CreateReviewRequest(
        @NotNull(message = "rating is required")
        @Min(value = 1, message = "rating must be at least 1")
        @Max(value = 5, message = "rating must be at most 5")
        Integer rating,

        @Size(max = 200, message = "title must be at most 200 characters")
        String title,

        String comment,

        LocalDate visitedAt) {
}
