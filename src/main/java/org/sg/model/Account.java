package org.sg.model;

import java.math.BigDecimal;
import static java.util.Objects.isNull;

public class Account {
    private BigDecimal balance;

    public Account(BigDecimal amount) {
        verifyAmount(amount, "Amount should be positive");
        this.balance = amount;
    }

    public BigDecimal deposit(BigDecimal amount) {
        verifyAmount(amount, "Deposit amount should be positive");
        this.balance = this.balance.add(amount);
        return this.balance;
    }

    public BigDecimal withDraw(BigDecimal amount) {
        verifyAmount(amount, "WithDraw amount should be positive");
        this.balance = this.balance.subtract(amount);
        return this.balance;
    }

    public BigDecimal getBalance() {
        return this.balance;
    }

    private void verifyAmount(BigDecimal amount, String message) {
        if (isNull(amount) || amount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException(message);
        }
    }
}
