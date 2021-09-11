package com.zstu.crm.workbench.service.impl;

import com.zstu.crm.settings.dao.UserDao;
import com.zstu.crm.settings.domain.User;
import com.zstu.crm.vo.PaginationVO;
import com.zstu.crm.workbench.dao.ActivityDao;
import com.zstu.crm.workbench.dao.ActivityRemarkDao;
import com.zstu.crm.workbench.domain.Activity;
import com.zstu.crm.workbench.domain.ActivityRemark;
import com.zstu.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service(value = "ActivityService")
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityDao activityDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private ActivityRemarkDao activityRemarkDao;

    @Override
    public List<ActivityRemark> getActivityRemarkList(String id) {
        return activityRemarkDao.getActivityRemarkList(id);
    }

    @Override
    public List<User> getUserList(){
        List<User> userList =userDao.getUserList();
        return userList;
    }

    @Override
    public boolean createActivity(Activity activity) {
        int count = activityDao.createActivity(activity);
        if(count==1){
            return true;
        }
        return false;
    }
    @Override
    public PaginationVO<Activity> pageActivity(Map<String,Object> map){
         PaginationVO<Activity> paginationVO =new PaginationVO();
         paginationVO.setTotal(activityDao.selectTotal(map));
         paginationVO.setDatalist(activityDao.getActivityList(map));
         //System.out.println(paginationVO);

          return paginationVO;
    }
    @Override
    public Boolean deleteActivity(String[] ids){
        //System.out.println(ids);
        boolean flag=true;
        Integer count1=activityRemarkDao.selectActivityRemarkCount(ids);
        Integer count2=activityRemarkDao.deleteActivityRemark(ids);
        Integer count3 =activityDao.deleteActivity(ids);
        if (count1!=count2){
            flag=false;
        }
        if (count3 !=ids.length){
            flag=false;
        }
        return flag;
    }
    @Override
    public Activity getActivityById(String id){

        return activityDao.getActivityById(id);
    }

    @Override
    public Boolean updateActivity(Activity activity) {
        int count = activityDao.updateActivity(activity);
        if(count==1){
            return true;
        }
        return false;
    }

    @Override
    public Boolean createActivityRemark(ActivityRemark activityRemark) {
        int count = activityRemarkDao.createActivityRemark(activityRemark);
        if(count==1){
            return true;
        }
        return false;
    }
}
