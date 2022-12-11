package org.sg.model;

import java.math.BigDecimal;
import java.time.LocalDate;

import static java.util.Objects.isNull;

public class Operation {
    private OperationType operationType;
    private LocalDate date;
    private BigDecimal amount;

    public Operation(OperationType operationType, LocalDate date, BigDecimal amount) {
        if (isNull(operationType) || isNull(date) || isNull(amount)) {
            throw new IllegalArgumentException("Parameters should not be null");
        }
        this.operationType = operationType;
        this.date = date;
        this.amount = amount;
    }

    public OperationType getOperationType() {
        return operationType;
    }

    public LocalDate getDate() {
        return date;
    }

    public BigDecimal getAmount() {
        return amount;
    }
}
