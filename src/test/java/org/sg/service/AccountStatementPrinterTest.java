package org.sg.service;

import org.junit.jupiter.api.DisplayNameGeneration;
import org.junit.jupiter.api.DisplayNameGenerator;
import org.junit.jupiter.api.Test;
import org.sg.model.Account;
import org.sg.model.AccountOperation;
import org.sg.model.Operation;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;

import static java.util.Arrays.asList;
import static org.junit.jupiter.api.Assertions.*;
import static org.sg.model.OperationType.DEPOSIT;
import static org.sg.model.OperationType.WITHDRAW;

@DisplayNameGeneration(DisplayNameGenerator.ReplaceUnderscores.class)
class AccountStatementPrinterTest {
    @Test
    void should_format_operation_history() {
        AccountStatementPrinter accountStatementPrinter = new AccountStatementPrinter();
        ArrayList<Operation> operations = new ArrayList<>(
                asList(
                        new Operation(WITHDRAW, LocalDate.of(2022, 12, 8), new BigDecimal("20.25")),
                        new Operation(DEPOSIT, LocalDate.of(2022, 12, 9), new BigDecimal("55.35")),
                        new Operation(WITHDRAW, LocalDate.of(2022, 12, 10), new BigDecimal("32.20")),
                        new Operation(WITHDRAW, LocalDate.of(2022, 12, 11), new BigDecimal("60.45"))
                ));
        String format = accountStatementPrinter.format(new AccountOperation(new Account(new BigDecimal("40.66")), operations));
        assertEquals(format,
                "2022-12-08 - WITHDRAW - 20.25" + System.lineSeparator() +
                        "2022-12-09 - DEPOSIT - 55.35" + System.lineSeparator() +
                        "2022-12-10 - WITHDRAW - 32.20" + System.lineSeparator() +
                        "2022-12-11 - WITHDRAW - 60.45" + System.lineSeparator() +
                        "Balance 40.66");
    }
}