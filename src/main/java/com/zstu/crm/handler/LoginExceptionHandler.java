package com.zstu.crm.handler;

import com.zstu.crm.exception.LoginException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class LoginExceptionHandler {

    @ExceptionHandler(value = LoginException.class)
    @ResponseBody
    public Map<String,Object> login(Exception e){
        e.printStackTrace();
        String msg = e.getMessage();
        Map<String,Object> map = new HashMap<>();
        map.put("success",false);
        map.put("msg",msg);
        return map;
    }

}