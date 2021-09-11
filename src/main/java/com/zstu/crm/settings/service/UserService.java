package com.zstu.crm.settings.service;

import com.zstu.crm.exception.LoginException;
import com.zstu.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;
    List<User> getUserList();

    User getUserById(String owner);
}
