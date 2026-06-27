package com.snowresorts.resort.infrastructure.persistence;

import com.snowresorts.resort.domain.model.MapPackage;
import com.snowresorts.resort.domain.port.MapPackages;
import java.util.Optional;
import java.util.UUID;
import org.springframework.stereotype.Repository;

@Repository
public class MapPackageRepositoryAdapter implements MapPackages {

    private final MapPackageJpaRepository jpaRepository;

    public MapPackageRepositoryAdapter(MapPackageJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public Optional<MapPackage> findLatestByResortId(UUID resortId) {
        return jpaRepository.findFirstByResortIdOrderByVersionDesc(resortId).map(this::toDomain);
    }

    private MapPackage toDomain(MapPackageEntity entity) {
        return new MapPackage(
                entity.getResortId(),
                entity.getVersion(),
                entity.getS3Key(),
                entity.getChecksum(),
                entity.getSizeBytes());
    }
}
