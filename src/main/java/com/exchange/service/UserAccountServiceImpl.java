package com.exchange.service;

import com.exchange.dao.UserAccountDao;
import com.exchange.model.UserAccount;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service("userAccountService")
@Transactional
public class UserAccountServiceImpl implements UserAccountService {

    @Autowired
    UserAccountDao dao;

    @Override
    public List<UserAccount> findAll() {
        return dao.findAll();
    }

    @Override
    public UserAccount findById(int id) {
        return dao.findById(id);
    }

    @Override
    public List<UserAccount> findAllByUserId(int userId) {
        return dao.findAllByUserId(userId);
    }

    @Override
    public void saveAccount(UserAccount account) {
        dao.save(account);
    }

    @Override
    public void updateAccount(UserAccount account) {
        dao.upd(account);
    }

    @Override
    public void deleteById(int id) {
        dao.deleteById(id);
    }
}
