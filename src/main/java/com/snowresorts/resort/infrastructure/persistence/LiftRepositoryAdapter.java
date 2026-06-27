package com.snowresorts.resort.infrastructure.persistence;

import com.snowresorts.resort.domain.model.Lift;
import com.snowresorts.resort.domain.port.Lifts;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Repository;

@Repository
public class LiftRepositoryAdapter implements Lifts {

    private final LiftJpaRepository jpaRepository;

    public LiftRepositoryAdapter(LiftJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public List<Lift> findByResortId(UUID resortId) {
        return jpaRepository.findByResortId(resortId).stream().map(this::toDomain).toList();
    }

    @Override
    public List<Lift> findWithinRadius(double lat, double lng, double radiusMeters) {
        return jpaRepository.findWithinRadius(lat, lng, radiusMeters).stream().map(this::toDomain).toList();
    }

    private Lift toDomain(LiftEntity entity) {
        return new Lift(
                entity.getId(),
                entity.getResortId(),
                entity.getName(),
                GeometryMapper.toCoordinates(entity.getGeom()));
    }
}
