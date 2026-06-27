package com.snowresorts.resort.infrastructure.persistence;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.UUID;
import org.locationtech.jts.geom.LineString;

@Entity
@Table(schema = "resorts", name = "lifts")
public class LiftEntity {

    @Id
    @Column(nullable = false, updatable = false)
    private UUID id;

    @Column(name = "resort_id", nullable = false)
    private UUID resortId;

    @Column(nullable = false)
    private String name;

    @Column(columnDefinition = "geometry(LineString,4326)")
    private LineString geom;

    protected LiftEntity() {
    }

    public UUID getId() {
        return id;
    }

    public UUID getResortId() {
        return resortId;
    }

    public String getName() {
        return name;
    }

    public LineString getGeom() {
        return geom;
    }
}
