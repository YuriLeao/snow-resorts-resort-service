package com.snowresorts.resort.infrastructure.persistence;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(schema = "resorts", name = "resort_reviews")
public class ResortReviewEntity {

    @Id
    @Column(nullable = false, updatable = false)
    private UUID id;

    @Column(name = "resort_id", nullable = false)
    private UUID resortId;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(nullable = false)
    private int rating;

    @Column(length = 200)
    private String title;

    @Column(columnDefinition = "text")
    private String comment;

    @Column(name = "visited_at")
    private LocalDate visitedAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    protected ResortReviewEntity() {
    }

    public ResortReviewEntity(UUID id, UUID resortId, UUID userId, int rating, String title,
                              String comment, LocalDate visitedAt, Instant createdAt) {
        this.id = id;
        this.resortId = resortId;
        this.userId = userId;
        this.rating = rating;
        this.title = title;
        this.comment = comment;
        this.visitedAt = visitedAt;
        this.createdAt = createdAt;
    }

    public UUID getId() {
        return id;
    }

    public UUID getResortId() {
        return resortId;
    }

    public UUID getUserId() {
        return userId;
    }

    public int getRating() {
        return rating;
    }

    public String getTitle() {
        return title;
    }

    public String getComment() {
        return comment;
    }

    public LocalDate getVisitedAt() {
        return visitedAt;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
