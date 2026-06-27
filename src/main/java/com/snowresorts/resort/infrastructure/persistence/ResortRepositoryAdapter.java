package com.snowresorts.resort.infrastructure.persistence;

import com.snowresorts.resort.domain.model.Resort;
import com.snowresorts.resort.domain.port.Resorts;
import com.snowresorts.security.error.ResourceNotFoundException;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

@Repository
public class ResortRepositoryAdapter implements Resorts {

    private final ResortJpaRepository jpaRepository;

    public ResortRepositoryAdapter(ResortJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public Optional<Resort> findById(UUID id) {
        return jpaRepository.findById(id).map(this::toDomain);
    }

    @Override
    public Page<Resort> search(String country, String q, Double lat, Double lng, Double radiusMeters,
                               Pageable pageable) {
        String normalizedCountry = country == null || country.isBlank() ? null : country.trim();
        String normalizedQ = q == null || q.isBlank() ? null : q.trim();
        String qPattern = normalizedQ == null ? null : "%" + normalizedQ + "%";
        Page<ResortEntity> page;
        if (lat != null && lng != null && radiusMeters != null) {
            page = qPattern == null
                    ? jpaRepository.listNear(lat, lng, radiusMeters, normalizedCountry, pageable)
                    : jpaRepository.searchNear(lat, lng, radiusMeters, normalizedCountry, qPattern, pageable);
        } else {
            page = qPattern == null
                    ? jpaRepository.listCatalog(normalizedCountry, pageable)
                    : jpaRepository.searchCatalog(normalizedCountry, qPattern, pageable);
        }
        return page.map(this::toDomain);
    }

    @Override
    public void updateAggregate(UUID resortId, BigDecimal avgRating, int reviewCount) {
        ResortEntity entity = jpaRepository.findById(resortId)
                .orElseThrow(() -> ResourceNotFoundException.of("Resort", resortId));
        entity.setAvgRating(avgRating);
        entity.setReviewCount(reviewCount);
        entity.setUpdatedAt(Instant.now());
        jpaRepository.save(entity);
    }

    private Resort toDomain(ResortEntity entity) {
        return new Resort(
                entity.getId(),
                entity.getSlug(),
                entity.getName(),
                entity.getCountry(),
                entity.getLat(),
                entity.getLng(),
                entity.getOfficialUrl(),
                entity.getDescription(),
                entity.getAvgRating(),
                entity.getReviewCount());
    }
}
