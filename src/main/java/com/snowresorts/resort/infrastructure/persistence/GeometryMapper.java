package com.snowresorts.resort.infrastructure.persistence;

import java.util.ArrayList;
import java.util.List;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.LineString;

/** Decodes PostGIS {@link LineString} geometry into domain-friendly {@code [lng, lat]} pairs. */
final class GeometryMapper {

    private GeometryMapper() {
    }

    /** @return ordered {@code [lng, lat]} coordinates, or an empty list when geometry is absent. */
    static List<double[]> toCoordinates(LineString lineString) {
        if (lineString == null) {
            return List.of();
        }
        List<double[]> coordinates = new ArrayList<>(lineString.getNumPoints());
        for (Coordinate coordinate : lineString.getCoordinates()) {
            coordinates.add(new double[] {coordinate.getX(), coordinate.getY()});
        }
        return coordinates;
    }
}
