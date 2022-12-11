package org.sg.repository;

import org.sg.model.Account;
import org.sg.model.Operation;
import java.util.List;

public interface AccountOperationRepository {

    List<Operation> getHistory(Account account);
    void saveOperation(Account account, Operation operation);
}
