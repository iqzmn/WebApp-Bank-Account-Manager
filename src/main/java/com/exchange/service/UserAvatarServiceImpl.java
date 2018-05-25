package com.exchange.service;

import com.exchange.dao.UserAvatarDao;
import com.exchange.model.UserAvatar;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("UserAvatarService")
@Transactional
public class UserAvatarServiceImpl implements UserAvatarService {

    @Autowired
    UserAvatarDao dao;

    @Override
    public UserAvatar findById(int id) {
        return dao.findById(id);
    }

    @Override
    public UserAvatar findByUserId(int userId) {
        return dao.findByUserId(userId);
    }

    @Override
    public void saveAvatar(UserAvatar avatar) {
            dao.save(avatar);
    }

    @Override
    public void deleteById(int id) {
        dao.deleteById(id);
    }
}
