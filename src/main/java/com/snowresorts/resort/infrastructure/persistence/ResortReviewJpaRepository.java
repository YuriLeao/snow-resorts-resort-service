package com.snowresorts.resort.infrastructure.persistence;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ResortReviewJpaRepository extends JpaRepository<ResortReviewEntity, UUID> {

    boolean existsByResortIdAndUserId(UUID resortId, UUID userId);

    Optional<ResortReviewEntity> findByResortIdAndUserId(UUID resortId, UUID userId);

    Page<ResortReviewEntity> findByResortId(UUID resortId, Pageable pageable);

    @Query("SELECT r.rating FROM ResortReviewEntity r WHERE r.resortId = :resortId")
    List<Integer> findRatingsByResortId(@Param("resortId") UUID resortId);
}
