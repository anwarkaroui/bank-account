package org.sg.service;

import org.sg.model.Account;
import org.sg.model.Operation;
import org.sg.repository.AccountOperationRepository;
import org.sg.repository.AccountRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.sg.model.OperationType.DEPOSIT;
import static org.sg.model.OperationType.WITHDRAW;

public class AccountService {
    private AccountRepository accountRepository;
    private AccountOperationRepository accountOperationRepository;

    public AccountService(AccountRepository accountRepository, AccountOperationRepository accountOperationRepository) {
        this.accountRepository = accountRepository;
        this.accountOperationRepository = accountOperationRepository;
    }

    public void withDraw(Account account, BigDecimal amount) {
        account.withDraw(amount);
        accountRepository.saveAccount(account);
        accountOperationRepository.saveOperation(account, new Operation(WITHDRAW, LocalDate.now(), amount));
    }

    public void deposit(Account account, BigDecimal amount) {
        account.deposit(amount);
        accountRepository.saveAccount(account);
        accountOperationRepository.saveOperation(account, new Operation(DEPOSIT, LocalDate.now(), amount));
    }

    public List<Operation> consultOperationsHistory(Account account) {
        return accountOperationRepository.getHistory(account);
    }

}
