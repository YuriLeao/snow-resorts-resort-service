package com.snowresorts.resort.infrastructure.user;

import com.snowresorts.resort.application.InternalApiProperties;
import com.snowresorts.resort.domain.port.AuthorSummary;
import com.snowresorts.resort.domain.port.ReviewAuthors;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

@Service
public class UserServiceReviewAuthorsAdapter implements ReviewAuthors {

    private static final Logger log = LoggerFactory.getLogger(UserServiceReviewAuthorsAdapter.class);

    private final RestClient userServiceClient;
    private final InternalApiProperties internalApi;

    public UserServiceReviewAuthorsAdapter(RestClient userServiceClient, InternalApiProperties internalApi) {
        this.userServiceClient = userServiceClient;
        this.internalApi = internalApi;
    }

    @Override
    public Map<UUID, AuthorSummary> resolve(Collection<UUID> userIds) {
        if (userIds == null || userIds.isEmpty()) {
            return Map.of();
        }
        try {
            SummariesResponse response = userServiceClient.post()
                    .uri("/snow-resort-service/v1/users/internal/profiles/summaries")
                    .header(internalApi.header(), internalApi.secret())
                    .body(new SummariesRequest(List.copyOf(userIds)))
                    .retrieve()
                    .body(SummariesResponse.class);
            if (response == null || response.profiles() == null) {
                return Map.of();
            }
            return response.profiles().stream()
                    .collect(Collectors.toMap(
                            ProfileSummaryWire::userId,
                            summary -> new AuthorSummary(summary.displayName(), summary.avatarUrl())));
        } catch (Exception e) {
            log.warn("Could not resolve review authors from user-service: {}", e.getMessage());
            return Map.of();
        }
    }

    private record SummariesRequest(List<UUID> userIds) {
    }

    private record SummariesResponse(List<ProfileSummaryWire> profiles) {
    }

    private record ProfileSummaryWire(UUID userId, String displayName, String avatarUrl) {
    }
}
