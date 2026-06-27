package com.snowresorts.resort.infrastructure.web;

import java.util.List;
import org.springframework.data.domain.Page;

/** Stable pagination envelope returned to clients (avoids serializing Spring's {@code PageImpl}). */
public record PageResponse<T>(
        List<T> content,
        int page,
        int size,
        long totalElements,
        int totalPages) {

    public static <T> PageResponse<T> from(Page<T> page) {
        return new PageResponse<>(
                page.getContent(),
                page.getNumber(),
                page.getSize(),
                page.getTotalElements(),
                page.getTotalPages());
    }
}
