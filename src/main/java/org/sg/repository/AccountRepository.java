package org.sg.repository;

import org.sg.model.Account;

public interface AccountRepository {

    Account getAccount();
    Account saveAccount(Account account);
}
