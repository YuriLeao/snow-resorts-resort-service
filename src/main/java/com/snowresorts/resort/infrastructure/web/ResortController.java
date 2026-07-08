package com.snowresorts.resort.infrastructure.web;

import com.snowresorts.resort.application.ResortQueryService;
import com.snowresorts.security.error.BadRequestException;
import java.util.UUID;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** Public read endpoints for the resort catalog and detail. */
@RestController
@RequestMapping("/snow-resort-service/v1/resorts")
public class ResortController {

    private static final double DEFAULT_RADIUS_METERS = 25_000d;
    private static final double DEFAULT_NEARBY_RADIUS_KM = 100d;
    private static final double MAX_NEARBY_RADIUS_KM = 200d;

    private final ResortQueryService queryService;

    public ResortController(ResortQueryService queryService) {
        this.queryService = queryService;
    }

    @GetMapping
    public PageResponse<ResortSummary> list(
            @RequestParam(required = false) String country,
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String near,
            @RequestParam(name = "radiusM", required = false) Double radiusMeters,
            @PageableDefault(size = 50, sort = "name", direction = Sort.Direction.ASC) Pageable pageable) {

        Double lat = null;
        Double lng = null;
        Double radius = null;
        if (near != null && !near.isBlank()) {
            double[] point = parseNear(near);
            lat = point[0];
            lng = point[1];
            radius = radiusMeters != null ? radiusMeters : DEFAULT_RADIUS_METERS;
        }
        return queryService.list(country, q, lat, lng, radius, pageable);
    }

    @GetMapping("/{id}")
    public ResortDetail detail(@PathVariable UUID id) {
        return queryService.detail(id);
    }

    /**
     * All pistes and lifts within {@code radiusKm} (default 100, capped at 200) of the resort,
     * across every resort — lets the map render linked/neighbouring ski areas around the
     * selected one (e.g. the Chilean Tres Valles), not just its own runs.
     */
    @GetMapping("/{id}/nearby-geometry")
    public NearbyGeometry nearbyGeometry(
            @PathVariable UUID id,
            @RequestParam(name = "radiusKm", required = false) Double radiusKm) {
        double radius = radiusKm != null ? radiusKm : DEFAULT_NEARBY_RADIUS_KM;
        if (radius <= 0 || radius > MAX_NEARBY_RADIUS_KM) {
            throw new BadRequestException(
                    "radiusKm must be between 0 and %.0f.".formatted(MAX_NEARBY_RADIUS_KM));
        }
        return queryService.nearbyGeometry(id, radius);
    }

    private double[] parseNear(String near) {
        String[] parts = near.split(",");
        if (parts.length != 2) {
            throw new BadRequestException("near must be in the form 'lat,lng'.");
        }
        try {
            return new double[] {Double.parseDouble(parts[0].trim()), Double.parseDouble(parts[1].trim())};
        } catch (NumberFormatException ex) {
            throw new BadRequestException("near must contain two decimal coordinates 'lat,lng'.");
        }
    }
}
