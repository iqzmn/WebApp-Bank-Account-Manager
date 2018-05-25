package com.exchange.dao;

import com.exchange.model.UserAvatar;

public interface UserAvatarDao {

    UserAvatar findById(int id);

    void save (UserAvatar avatar);

    UserAvatar findByUserId(int userId);

    void deleteById(int id);
}
