package org.sg.model;

import org.junit.jupiter.api.DisplayNameGeneration;
import org.junit.jupiter.api.DisplayNameGenerator;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

@DisplayNameGeneration(DisplayNameGenerator.ReplaceUnderscores.class)
class AccountTest {
    @Test
    void should_not_be_able_to_create_account_with_null_initial_amount() {
        assertThrows(IllegalArgumentException.class, () -> new Account(null));
    }

    @Test
    void should_not_be_able_to_create_account_with_negative_initial_amount() {
        assertThrows(IllegalArgumentException.class, () -> new Account(new BigDecimal("-10")));
    }

    @Test
    void should_get_correct_amount() {
        // GIVEN
        Account account = new Account(new BigDecimal("50"));
        // WHEN
        account.deposit(new BigDecimal("10"));
        // THEN
        assertEquals(new BigDecimal("60"), account.getBalance());
    }

    @Test
    void should_get_80_balance_given_initial_amount_100_and_deposit_20() {
        // GIVEN
        Account account = new Account(new BigDecimal("100"));
        // WHEN
        account.withDraw(new BigDecimal("20"));
        // THEN
        assertEquals(new BigDecimal("80"), account.getBalance());
    }

    @Test
    void should_not_deposit_negative_amount() {
        // GIVEN
        Account account = new Account(new BigDecimal("100"));
        // THEN
        assertThrows(IllegalArgumentException.class, () -> account.deposit(new BigDecimal("-50")));
    }

    @Test
    void should_not_withDraw_negative_amount() {
        // GIVEN
        Account account = new Account(new BigDecimal("100"));
        // THEN
        assertThrows(IllegalArgumentException.class, () -> account.withDraw(new BigDecimal("-50")));
    }
}