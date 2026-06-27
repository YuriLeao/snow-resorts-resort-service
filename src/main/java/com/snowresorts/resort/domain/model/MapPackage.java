package com.snowresorts.resort.domain.model;

import java.util.UUID;

/** A versioned offline map bundle stored in S3/MinIO, referenced by key + integrity metadata. */
public record MapPackage(
        UUID resortId,
        int version,
        String s3Key,
        String checksum,
        Long sizeBytes) {
}
