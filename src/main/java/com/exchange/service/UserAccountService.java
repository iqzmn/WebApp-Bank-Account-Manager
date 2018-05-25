package com.exchange.service;

import com.exchange.model.UserAccount;

import java.util.List;

public interface UserAccountService {

    List<UserAccount> findAll();

    UserAccount findById(int id);

    List<UserAccount> findAllByUserId(int userId);

    void saveAccount(UserAccount account);

    void updateAccount(UserAccount account);

    void deleteById(int id);
}
