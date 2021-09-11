package com.zstu.crm.settings.web.controller;



import com.zstu.crm.exception.LoginException;
import com.zstu.crm.settings.domain.User;
import com.zstu.crm.settings.service.UserService;
import com.zstu.crm.utils.MD5Util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/settings/user")
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping(value = "/login.do",produces ="application/json")
    @ResponseBody
    public Map<String,Object> LoginService(HttpServletRequest request, User user) throws LoginException {
        //System.out.println("用户登录控制器");
        String loginAct = user.getLoginAct();
        String loginPwd = user.getLoginPwd();
        loginPwd = MD5Util.getMD5(loginPwd);
       // System.out.println(loginAct+loginPwd);
        String ip =request.getRemoteAddr();
        //System.out.println("ip="+ip);
        Map<String,Object> loginMap =new HashMap<>();
        user =userService.login(loginAct, loginPwd, ip);
        request.getSession().setAttribute("user",user);
        loginMap.put("success",true);
        return loginMap;
    }


}
