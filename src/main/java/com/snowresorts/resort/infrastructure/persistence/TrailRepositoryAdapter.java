package com.snowresorts.resort.infrastructure.persistence;

import com.snowresorts.resort.domain.model.Difficulty;
import com.snowresorts.resort.domain.model.Trail;
import com.snowresorts.resort.domain.port.Trails;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Repository;

@Repository
public class TrailRepositoryAdapter implements Trails {

    private final TrailJpaRepository jpaRepository;

    public TrailRepositoryAdapter(TrailJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public List<Trail> findByResortId(UUID resortId) {
        return jpaRepository.findByResortId(resortId).stream().map(this::toDomain).toList();
    }

    @Override
    public List<Trail> findWithinRadius(double lat, double lng, double radiusMeters) {
        return jpaRepository.findWithinRadius(lat, lng, radiusMeters).stream().map(this::toDomain).toList();
    }

    private Trail toDomain(TrailEntity entity) {
        return new Trail(
                entity.getId(),
                entity.getResortId(),
                entity.getName(),
                Difficulty.fromCode(entity.getDifficulty()),
                GeometryMapper.toCoordinates(entity.getGeom()));
    }
}
