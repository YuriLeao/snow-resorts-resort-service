package com.snowresorts.resort.domain.port;

import com.snowresorts.resort.domain.model.ResortReview;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/** Outbound port for resort reviews. */
public interface ResortReviews {

    boolean existsByResortIdAndUserId(UUID resortId, UUID userId);

    Optional<ResortReview> findById(UUID reviewId);

    Optional<ResortReview> findByResortIdAndUserId(UUID resortId, UUID userId);

    Page<ResortReview> findByResortId(UUID resortId, Pageable pageable);

    /** @return all ratings for a resort, used to recompute the cached aggregate. */
    List<Integer> findRatingsByResortId(UUID resortId);

    ResortReview save(ResortReview review);

    void deleteById(UUID reviewId);
}
