package com.zstu.crm.workbench.dao;

import com.zstu.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int createActivity(Activity activity);

    Integer selectTotal(Map<String,Object> map);

    List<Activity> getActivityList(Map<String,Object> map);

    Integer deleteActivity(String[] ids);

    Activity getActivityById(String id);

    int updateActivity(Activity activity);
}
