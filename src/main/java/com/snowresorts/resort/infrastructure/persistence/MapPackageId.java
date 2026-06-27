package com.snowresorts.resort.infrastructure.persistence;

import java.io.Serializable;
import java.util.Objects;
import java.util.UUID;

/** Composite primary key for {@link MapPackageEntity} ({@code resort_id} + {@code version}). */
public class MapPackageId implements Serializable {

    private UUID resortId;
    private int version;

    protected MapPackageId() {
    }

    public MapPackageId(UUID resortId, int version) {
        this.resortId = resortId;
        this.version = version;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof MapPackageId that)) {
            return false;
        }
        return version == that.version && Objects.equals(resortId, that.resortId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(resortId, version);
    }
}
