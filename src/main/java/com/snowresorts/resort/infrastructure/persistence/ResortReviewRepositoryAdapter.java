package com.snowresorts.resort.infrastructure.persistence;

import com.snowresorts.resort.domain.model.ResortReview;
import com.snowresorts.resort.domain.port.ResortReviews;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

@Repository
public class ResortReviewRepositoryAdapter implements ResortReviews {

    private final ResortReviewJpaRepository jpaRepository;

    public ResortReviewRepositoryAdapter(ResortReviewJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public boolean existsByResortIdAndUserId(UUID resortId, UUID userId) {
        return jpaRepository.existsByResortIdAndUserId(resortId, userId);
    }

    @Override
    public Optional<ResortReview> findById(UUID reviewId) {
        return jpaRepository.findById(reviewId).map(this::toDomain);
    }

    @Override
    public Optional<ResortReview> findByResortIdAndUserId(UUID resortId, UUID userId) {
        return jpaRepository.findByResortIdAndUserId(resortId, userId).map(this::toDomain);
    }

    @Override
    public Page<ResortReview> findByResortId(UUID resortId, Pageable pageable) {
        return jpaRepository.findByResortId(resortId, pageable).map(this::toDomain);
    }

    @Override
    public List<Integer> findRatingsByResortId(UUID resortId) {
        return jpaRepository.findRatingsByResortId(resortId);
    }

    @Override
    public ResortReview save(ResortReview review) {
        ResortReviewEntity saved = jpaRepository.save(new ResortReviewEntity(
                review.id(),
                review.resortId(),
                review.userId(),
                review.rating(),
                review.title(),
                review.comment(),
                review.visitedAt(),
                review.createdAt()));
        return toDomain(saved);
    }

    @Override
    public void deleteById(UUID reviewId) {
        jpaRepository.deleteById(reviewId);
    }

    private ResortReview toDomain(ResortReviewEntity entity) {
        return new ResortReview(
                entity.getId(),
                entity.getResortId(),
                entity.getUserId(),
                entity.getRating(),
                entity.getTitle(),
                entity.getComment(),
                entity.getVisitedAt(),
                entity.getCreatedAt());
    }
}
