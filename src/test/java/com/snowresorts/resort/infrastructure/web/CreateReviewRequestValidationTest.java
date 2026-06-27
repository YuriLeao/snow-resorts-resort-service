package com.snowresorts.resort.infrastructure.web;

import static org.assertj.core.api.Assertions.assertThat;

import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

/** DTO-layer validation: rating must be within 1..5 and title length-bounded. */
class CreateReviewRequestValidationTest {

    private static ValidatorFactory factory;
    private static Validator validator;

    @BeforeAll
    static void setUp() {
        factory = Validation.buildDefaultValidatorFactory();
        validator = factory.getValidator();
    }

    @AfterAll
    static void tearDown() {
        factory.close();
    }

    @Test
    @DisplayName("rating above 5 produces a constraint violation")
    void validate_ratingOutOfRange_hasViolation() {
        CreateReviewRequest request = new CreateReviewRequest(6, "Nice", "Comment", null);

        assertThat(validator.validate(request))
                .anyMatch(v -> v.getPropertyPath().toString().equals("rating"));
    }

    @Test
    @DisplayName("a valid review payload produces no violations")
    void validate_validRequest_hasNoViolations() {
        CreateReviewRequest request = new CreateReviewRequest(4, "Nice", "Comment", null);

        assertThat(validator.validate(request)).isEmpty();
    }

    @Test
    @DisplayName("null rating is rejected")
    void validate_nullRating_hasViolation() {
        CreateReviewRequest request = new CreateReviewRequest(null, "Nice", "Comment", null);

        assertThat(validator.validate(request))
                .anyMatch(v -> v.getPropertyPath().toString().equals("rating"));
    }
}
