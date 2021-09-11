package com.zstu.crm.workbench.dao;

import com.zstu.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    List<ActivityRemark> getActivityRemarkList(String id);

    int createActivityRemark(ActivityRemark activityRemark);

    Integer deleteActivityRemark(String[] ids);

    Integer selectActivityRemarkCount(String[] ids);
}
