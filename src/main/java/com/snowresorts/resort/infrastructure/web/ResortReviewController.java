package com.snowresorts.resort.infrastructure.web;

import com.snowresorts.resort.application.ResortReviewService;
import com.snowresorts.security.SecurityUtils;
import jakarta.validation.Valid;
import java.util.UUID;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

/**
 * Resort reviews. Listing is public; create/update/delete require authentication and ownership.
 * The authenticated user id is the JWT {@code sub} via {@link SecurityUtils#requireCurrentUserId()}.
 */
@RestController
@RequestMapping("/snow-resort-service/v1/resorts/{resortId}/reviews")
public class ResortReviewController {

    private final ResortReviewService reviewService;

    public ResortReviewController(ResortReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @GetMapping
    public PageResponse<ReviewResponse> list(
            @PathVariable UUID resortId,
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable) {
        return reviewService.listReviews(resortId, pageable);
    }

    @GetMapping("/me")
    public ResponseEntity<ReviewResponse> getMyReview(@PathVariable UUID resortId) {
        UUID userId = SecurityUtils.requireCurrentUserId();
        return reviewService.findMyReview(resortId, userId)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ReviewResponse create(
            @PathVariable UUID resortId,
            @Valid @RequestBody CreateReviewRequest request) {
        UUID userId = SecurityUtils.requireCurrentUserId();
        return reviewService.create(resortId, userId, request.rating(),
                request.title(), request.comment(), request.visitedAt());
    }

    @PutMapping("/{reviewId}")
    public ReviewResponse update(
            @PathVariable UUID resortId,
            @PathVariable UUID reviewId,
            @Valid @RequestBody UpdateReviewRequest request) {
        UUID userId = SecurityUtils.requireCurrentUserId();
        return reviewService.update(resortId, reviewId, userId, request.rating(),
                request.title(), request.comment(), request.visitedAt());
    }

    @DeleteMapping("/{reviewId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(
            @PathVariable UUID resortId,
            @PathVariable UUID reviewId) {
        UUID userId = SecurityUtils.requireCurrentUserId();
        reviewService.delete(resortId, reviewId, userId);
    }
}
