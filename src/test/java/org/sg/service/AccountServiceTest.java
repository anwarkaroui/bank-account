package org.sg.service;

import org.junit.jupiter.api.DisplayNameGeneration;
import org.junit.jupiter.api.DisplayNameGenerator;
import org.junit.jupiter.api.Test;
import org.sg.model.Account;

import static java.time.LocalDate.now;

import org.sg.model.Operation;
import org.sg.repository.AccountOperationRepository;
import org.sg.repository.AccountRepository;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.sg.model.OperationType.DEPOSIT;
import static org.sg.model.OperationType.WITHDRAW;

@DisplayNameGeneration(DisplayNameGenerator.ReplaceUnderscores.class)
class AccountServiceTest {

    @Test
    void should_withdraw_to_account() {
        // given
        AccountRepository accountRepository = getAccountRepository(new BigDecimal("100"));
        Account account = accountRepository.getAccount();
        AccountService accountService = new AccountService(accountRepository, getAccountOperationRepository());
        //when
        accountService.withDraw(account, new BigDecimal("50"));
        //then
        Account accountFinal = accountRepository.getAccount();
        assertNotNull(accountFinal);
        assertEquals(accountFinal.getBalance(), new BigDecimal("50"));
    }


    @Test
    void should_deposit_to_account() {
        // given
        AccountRepository accountRepository = getAccountRepository(new BigDecimal("100"));
        Account account = accountRepository.getAccount();
        AccountService accountService = new AccountService(accountRepository, getAccountOperationRepository());
        //when
        accountService.deposit(account, new BigDecimal("50"));
        //then
        Account accountFinal = accountRepository.getAccount();
        assertNotNull(accountFinal);
        assertEquals(accountFinal.getBalance(), new BigDecimal("150"));
    }

    @Test
    void should_display_history() {
        // given
        AccountRepository accountRepository = getAccountRepository(BigDecimal.TEN);
        Account account = accountRepository.getAccount();
        AccountOperationRepository accountOperationRepository = getAccountOperationRepository();
        AccountService accountService = new AccountService(accountRepository, accountOperationRepository);

        // when
        accountService.deposit(account, new BigDecimal("50"));
        accountService.withDraw(account, new BigDecimal("60"));
        accountService.deposit(account, new BigDecimal("70"));

        // then
        List<Operation> history = accountService.operationsHistory(account);
        assertNotNull(history);
        assertEquals(3, history.size());
        assertEquals(history.get(0), new Operation(DEPOSIT, now(), new BigDecimal("50")));
        assertEquals(history.get(1), new Operation(WITHDRAW, now(), new BigDecimal("60")));
        assertEquals(history.get(2), new Operation(DEPOSIT, now(), new BigDecimal("70")));
    }


   private AccountRepository getAccountRepository(BigDecimal amount){
        return new AccountRepository() {
            private Account account = new Account(amount);
            @Override
            public Account getAccount() {
                return this.account;
            }

            @Override
            public void saveAccount(Account account) {
                this.account = account;
            }
        };
   }

   private AccountOperationRepository getAccountOperationRepository(){
        return new AccountOperationRepository() {

            private final List<Operation> operationHistory = new ArrayList<>();
            @Override
            public List<Operation> getHistory(Account account) {
                return operationHistory;
            }

            @Override
            public void saveOperation(Account account, Operation operation) {
                this.operationHistory.add(operation);

            }
        };
   }



}