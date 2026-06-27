package com.snowresorts.resort.domain.model;

import com.snowresorts.security.error.BadRequestException;

/** Ski trail difficulty grade. Persisted as a lowercase code (green|blue|black|red). */
public enum Difficulty {
    GREEN,
    BLUE,
    BLACK,
    RED;

    /** @return the lowercase persistence/wire code for this grade. */
    public String code() {
        return name().toLowerCase();
    }

    /** Parses a stored/wire code into a grade, rejecting unknown values. */
    public static Difficulty fromCode(String code) {
        if (code == null || code.isBlank()) {
            throw new BadRequestException("difficulty is required.");
        }
        try {
            return Difficulty.valueOf(code.trim().toUpperCase());
        } catch (IllegalArgumentException ex) {
            throw new BadRequestException("Unknown trail difficulty: '%s'.".formatted(code));
        }
    }
}
