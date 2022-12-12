package org.sg.model;

import org.junit.jupiter.api.DisplayNameGeneration;
import org.junit.jupiter.api.DisplayNameGenerator;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayNameGeneration(DisplayNameGenerator.ReplaceUnderscores.class)
class OperationTest {

    @Test
    void should_not_create_invalid_operation() {
        assertThrows(IllegalArgumentException.class, () -> new Operation(null, null, null));
    }

}