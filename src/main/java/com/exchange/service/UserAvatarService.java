package com.exchange.service;

import com.exchange.model.UserAvatar;

public interface UserAvatarService {

    UserAvatar findById(int id);

    UserAvatar findByUserId(int userId);

    void saveAvatar(UserAvatar avatar);

    void deleteById(int id);

}
