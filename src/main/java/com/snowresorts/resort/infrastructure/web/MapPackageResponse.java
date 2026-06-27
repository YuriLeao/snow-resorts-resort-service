package com.snowresorts.resort.infrastructure.web;

import com.snowresorts.resort.domain.model.MapPackage;

/** Latest offline map package metadata for a resort. */
public record MapPackageResponse(
        int version,
        String s3Key,
        String checksum,
        Long sizeBytes) {

    public static MapPackageResponse from(MapPackage mapPackage) {
        return new MapPackageResponse(
                mapPackage.version(),
                mapPackage.s3Key(),
                mapPackage.checksum(),
                mapPackage.sizeBytes());
    }
}
