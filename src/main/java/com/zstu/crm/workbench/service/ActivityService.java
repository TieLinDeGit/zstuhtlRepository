package com.zstu.crm.workbench.service;

import com.zstu.crm.settings.domain.User;
import com.zstu.crm.vo.PaginationVO;
import com.zstu.crm.workbench.domain.Activity;
import com.zstu.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    List<ActivityRemark> getActivityRemarkList(String id);

    List<User> getUserList();

    boolean createActivity(Activity activity);

    PaginationVO<Activity> pageActivity(Map<String,Object> map);

    Boolean deleteActivity(String[] ids);

    Activity getActivityById(String id);

    Boolean updateActivity(Activity activity);

    Boolean createActivityRemark(ActivityRemark activityRemark);
}
