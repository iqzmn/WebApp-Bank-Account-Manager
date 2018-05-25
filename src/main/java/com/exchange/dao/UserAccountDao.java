package com.exchange.dao;

import com.exchange.model.UserAccount;

import java.util.List;

public interface UserAccountDao {

    List<UserAccount> findAll();

    UserAccount findById(int id);

    void save (UserAccount avatar);

    void upd(UserAccount account);

    List<UserAccount> findAllByUserId(int userId);

    void deleteById(int id);
}
