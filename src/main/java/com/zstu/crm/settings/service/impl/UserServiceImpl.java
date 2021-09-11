package com.zstu.crm.settings.service.impl;

import com.zstu.crm.exception.LoginException;
import com.zstu.crm.settings.dao.UserDao;
import com.zstu.crm.settings.domain.User;
import com.zstu.crm.settings.service.UserService;
import com.zstu.crm.utils.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service(value = "UserService")
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException{
       // System.out.println("验证登录");
        Map<String,String> map =new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        System.out.println(loginAct+"-----"+loginPwd);
        User user =userDao.login(map);
        System.out.println(user);
        if(user == null){
            throw new LoginException("账号密码错误");
        }
        String expireTime = user.getExpireTime();
        String currentTime=DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime)<0){
            throw new LoginException("账号已失效");
        }
        String allowIps =user.getAllowIps();
        System.out.println(allowIps);
        if (!allowIps.contains(ip)){
            throw new LoginException("账号ip错误");
        }
        if ("0".equals(user.getLockState())){
            throw new LoginException("账号已经被锁定");
        }
        System.out.println("验证结束");
        return user;
    }
    @Override
    public List<User> getUserList(){
        List<User> userList =userDao.getUserList();
        return userList;
    }

    @Override
    public User getUserById(String owner) {
        User user=userDao.getUserById(owner);
        return user;
    }
}
