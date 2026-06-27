package com.snowresorts.resort.infrastructure.persistence;

import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/** Provides a shared WGS-84 (SRID 4326) {@link GeometryFactory} for building/decoding geometries. */
@Configuration(proxyBeanMethods = false)
public class GeometryConfig {

    /** SRID 4326 = WGS-84 lat/lng, matching the PostGIS {@code geometry(...,4326)} columns. */
    public static final int SRID_WGS84 = 4326;

    @Bean
    public GeometryFactory geometryFactory() {
        return new GeometryFactory(new PrecisionModel(), SRID_WGS84);
    }
}
