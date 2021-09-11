package com.zstu.crm.workbench.web.controller;

import com.zstu.crm.settings.domain.User;
import com.zstu.crm.settings.service.UserService;
import com.zstu.crm.utils.DateTimeUtil;
import com.zstu.crm.utils.UUIDUtil;
import com.zstu.crm.vo.PaginationVO;
import com.zstu.crm.workbench.domain.Activity;
import com.zstu.crm.workbench.domain.ActivityRemark;
import com.zstu.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Autowired
    private ActivityService activityService;
    @Autowired
    private UserService userService;

    @RequestMapping("/pageActivity.do")
    @ResponseBody
    private PaginationVO<Activity> pageActivity(Activity activity,Integer pageNo,Integer pageSize){
        //System.out.println("展示市场活动页面");
        String name =activity.getName();
        String owner=activity.getOwner();
        String startDate=activity.getStartDate();
        String endDate=activity.getEndDate();
        int skipCount = (pageNo-1)*pageSize;
        Map<String,Object> map =new HashMap<>();

        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        //System.out.println(map);

        return activityService.pageActivity(map);
    }

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> getUserList(){
        //System.out.println("展现用户信息---------下拉框");
        List<User> uList =userService.getUserList();
        return uList;
    }
    @RequestMapping("/saveActivity.do")
    @ResponseBody
    private Boolean saveActivity(HttpServletRequest request, Activity activity){
        System.out.println("市场活动添加模块");
        Map<String,Object> map =new HashMap<>();

        User user =(User) request.getSession().getAttribute("user");

        String createBy =user.getId();
        //System.out.println(createBy);
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateBy(createBy);
        activity.setCreateTime(DateTimeUtil.getSysTime());
       // System.out.println(activity);
        Boolean flag=activityService.createActivity(activity);

        return flag;

    }
    @RequestMapping("/updateActivity.do")
    @ResponseBody
    private Boolean updateActivity(HttpServletRequest request, Activity activity){
        Boolean flag=true;
        System.out.println("市场活动修改模块");
        Map<String,Object> map =new HashMap<>();
        User user =(User) request.getSession().getAttribute("user");
        String editBy =user.getId();
        activity.setEditBy(editBy);
        activity.setEditTime(DateTimeUtil.getSysTime());
        // System.out.println(activity);
        flag=activityService.updateActivity(activity);
        return flag;
    }
    @RequestMapping("/deleteActivity.do")
    @ResponseBody
    private Boolean deleteActivity(@RequestParam(value = "id") String[] ids){
        System.out.println("删除市场活动");
        return activityService.deleteActivity(ids);
    }
    @RequestMapping("/getUserListAndActivity.do")
    @ResponseBody
    private Map<String,Object> getUserListAndActivity(String id){
        List<User> uList =userService.getUserList();
        Activity activity=activityService.getActivityById(id);
        Map<String,Object> map =new HashMap<>();
        map.put("uList",uList);
        map.put("activity",activity);
        return map;
    }
    @RequestMapping("/detail.do")
    @ResponseBody
    private ModelAndView getActivityDetail(String id){
        ModelAndView mv =new ModelAndView();
        Activity activity=activityService.getActivityById(id);
        System.out.println(activity);
        mv.addObject(activity);
        mv.setViewName("forward:/workbench/activity/detail.jsp");
        return mv;
    }
    @RequestMapping("/getActivityRemark.do")
    @ResponseBody
    private List<ActivityRemark> getActivityRemark(String id){
        System.out.println("市场活动备注展示模块");
        //System.out.println(id);
        List<ActivityRemark> activityRemarkList =activityService.getActivityRemarkList(id);
        System.out.println(activityRemarkList);
        return activityRemarkList;
    }
    @RequestMapping("/createActivityRemark.do")
    @ResponseBody
    private Boolean createActivityRemark(HttpServletRequest request,String id,String msg){
        System.out.println("市场活动备注添加模块");
        Boolean flag = true;
        //System.out.println(id);
        //System.out.println(msg);
        ActivityRemark activityRemark =new ActivityRemark();
        activityRemark.setActivityId(id);
        activityRemark.setNoteContent(msg);
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setEditFlag("0");
        User user =(User) request.getSession().getAttribute("user");
        activityRemark.setCreateBy(user.getId());
        flag=activityService.createActivityRemark(activityRemark);
        return flag;
    }





}
