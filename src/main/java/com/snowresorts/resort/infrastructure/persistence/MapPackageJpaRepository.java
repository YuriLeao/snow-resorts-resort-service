package com.snowresorts.resort.infrastructure.persistence;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MapPackageJpaRepository extends JpaRepository<MapPackageEntity, MapPackageId> {

    Optional<MapPackageEntity> findFirstByResortIdOrderByVersionDesc(UUID resortId);
}
