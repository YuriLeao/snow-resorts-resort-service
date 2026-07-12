package com.snowresorts.resort.domain.port;

import java.util.UUID;

/** Display fields for a review author resolved from user-service. */
public record AuthorSummary(String displayName, String avatarUrl) {

    public static String fallbackDisplayName(UUID userId) {
        return "User" + userId.toString().substring(0, 8);
    }
}
