package com.snowresorts.resort.domain.port;

import java.util.Collection;
import java.util.Map;
import java.util.UUID;

/** Outbound port for resolving review author display names and avatars. */
public interface ReviewAuthors {

    Map<UUID, AuthorSummary> resolve(Collection<UUID> userIds);
}
