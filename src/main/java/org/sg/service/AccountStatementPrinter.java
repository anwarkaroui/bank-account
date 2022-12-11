package org.sg.service;

import org.sg.model.Account;
import org.sg.model.AccountOperation;
import org.sg.model.Operation;

import java.util.List;

import static java.lang.System.lineSeparator;
import static java.util.stream.Collectors.joining;

public class AccountStatementPrinter {

    public static final String SEPARATOR = " - ";

    public String format(AccountOperation accountOperation) {
        String formatAccount = format(accountOperation.getAccount());
        String formatOperations = format(accountOperation.getOperations());
        return formatOperations + lineSeparator() + formatAccount;
    }

    private String format(List<Operation> operations) {
        return operations
                .stream()
                .map(this::formatOperation)
                .collect(joining(lineSeparator()));
    }

    private String formatOperation(Operation operation) {
        return operation.getDate().toString()
                + SEPARATOR
                + operation.getOperationType()
                + SEPARATOR
                + operation.getAmount();
    }

    private String format(Account account) {
        return "Balance " + account.getBalance().toString();
    }
}
