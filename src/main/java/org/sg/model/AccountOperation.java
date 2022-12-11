package org.sg.model;

import java.util.List;

public class AccountOperation {
    private Account account;
    private List<Operation> operations;

    public AccountOperation(Account account, List<Operation> operations) {
        this.account = account;
        this.operations = operations;
    }

    public Account getAccount() {
        return account;
    }

    public List<Operation> getOperations() {
        return operations;
    }
}
