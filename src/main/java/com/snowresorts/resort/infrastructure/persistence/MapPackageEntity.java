package com.snowresorts.resort.infrastructure.persistence;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import java.util.UUID;

@Entity
@Table(schema = "resorts", name = "resort_map_packages")
@IdClass(MapPackageId.class)
public class MapPackageEntity {

    @Id
    @Column(name = "resort_id", nullable = false)
    private UUID resortId;

    @Id
    @Column(nullable = false)
    private int version;

    @Column(name = "s3_key", nullable = false)
    private String s3Key;

    @Column
    private String checksum;

    @Column(name = "size_bytes")
    private Long sizeBytes;

    protected MapPackageEntity() {
    }

    public UUID getResortId() {
        return resortId;
    }

    public int getVersion() {
        return version;
    }

    public String getS3Key() {
        return s3Key;
    }

    public String getChecksum() {
        return checksum;
    }

    public Long getSizeBytes() {
        return sizeBytes;
    }
}
