<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">
       /*
(function($){
		$.fn.datetimepicker.dates['zh-CN'] = {
			days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
			daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
			daysMin:  ["日", "一", "二", "三", "四", "五", "六", "日"],
			months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
			monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
			today: "今天",
			suffix: [],
			meridiem: ["上午", "下午"]
		};
	}(jQuery));
*/
	 $(function(){

	 	$(".time").datetimepicker({
		 minView: "month",
		 language:  'zh-CN',
		 format: 'yyyy-mm-dd',
		 autoclose: true,
		 todayBtn: true,
		 pickerPosition: "bottom-left"
	 });

		$("#createActivityBtn").click(function () {

			//alert("123");
			//$("#createActivityModal").modal("show");
			$.ajax({

                url :"workbench/activity/getUserList.do",
				data:{},
                type : "get",
                dataType : "json",
                success : function (data) {
					var html="";
					$.each(data,function (i,n) {
						html+="<option value="+n.id+">"+n.name+"</option>";
					});
					//alert(html);
                    $("#create-Owner").html(html);
					var id ="${user.id}"
                    $("#create-Owner").val(id);
					$("#createActivityModal").modal("show");

                }
            })
		})
		 pageList(1,2);//分页
		 $("#saveActivityBtn").click(function () {
		 	//alert($("#create-marketActivityName").val())

			 var name =$.trim($("#create-marketActivityName").val());
			 var cost=$.trim($("#create-cost").val());
			 var description=$.trim($("#create-describe").val());
			 if(name==""){
			 	alert("名称不能为空")
				 return false
			 }
			 $.ajax({
				 url : "workbench/activity/saveActivity.do",
				 data : {
					"owner":$.trim($("#create-Owner").val()),
					"name":name,
					"startDate":$.trim($("#create-startTime").val()),
					"endDate":$.trim($("#create-endTime").val()),
					"cost":cost,
					"description":description,
				 },
				 type : "post",
				 dataType : "json",
				 success : function (data) {
				 	if (data){
						$("#activityAddForm")[0].reset();
						alert("添加成功")
						$("#createActivityModal").modal("hide");
						/**
						 * 注意:
						 * 		我们拿到了form表单的jquery对象,
						 * 		对于表单的jquery对象,提供了submit()方法让我们提交表单
						 * 		但是表单的jquery对象,没有为我们提供reset()方法让我们重置表单(坑: idea为我们提示了又reset()方法)
						 *
						 * 		虽然jquery对象没有为我们提供reset()方法,但是原生的js为我们提供了reset方法
						 *		我们要将jquery对象,转换为原生js对象
						 *
						 *		jquery对象转换为dom对象:
						 *			jquery对象[下标]
						 *
						 *		dom对象如何转换为jquery对象:
						 *			$(dom)
						 */

						// 关闭添加操作的模态窗口
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

					}else {
				 		alert("添加失败")
					}
				 }
			 })
		 })

		 $("#searchActivityBtn").click(function () {
		 	$("#hidden-name").val($.trim($("#searchActivityName").val()));
			 $("#hidden-owner").val($.trim($("#searchActivityOwner").val()));
			 $("#hidden-startDate").val($.trim($("#searchActivityStartTime").val()));
			 $("#hidden-endDate").val($.trim($("#searchActivityEndTime").val()));

		 	pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'))
		 })
         //单选  复选框 操作
		 $("#qx").click(function () {
		 	$("input[name='xz']").prop("checked",this.checked);
		 })
		 $("#activityBody").on("click","input[name='xz']",function () {
			 $("#qx").prop("checked",$("input[name='xz']:checked").size()==$("input[name='xz']").size());
		 })

		 $("#deleteActivityBtn").click(function () {
			 var $xz =$("input[name='xz']:checked");
		 	if($("input[name='xz']:checked").size()==0){
		 		alert("请选择删除的市场活动")
			}else {
				if(confirm("确定删除吗？")){
					var param ="";
					for (var i=0;i<$xz.length;i++){
						param +="id="+$($xz[i]).val();
						if(i<$xz.length-1){
							param +="&";
						}
					}
					$.ajax({

						url : "workbench/activity/deleteActivity.do",
						data :param,
						type : "post",
						dataType : "json",
						success : function (data) {
							if(data){
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'))
							}else {
							alert("删除失败")
							}
						}
					})
				}
			}
		 	//alert(param);
		 })

		 $("#editActivityBtn").click(function () {
			 var $xz =$("input[name='xz']:checked");
			 if($("input[name='xz']:checked").size()!=1){
				 alert("请选择一条要修改的市场活动")
			 }else {
				 var id =$xz.val();
				 $.ajax({

					 url : "workbench/activity/getUserListAndActivity.do",
					 data : {"id":id
					 },
					 type : "get",
					 dataType : "json",
					 success : function (data) {
						 var html="";
						 $.each(data.uList,function (i,n) {
							 html+="<option value="+n.id+">"+n.name+"</option>";
						 });
						 //alert(html);
						 $("#edit-marketActivityOwner").html(html);
						 var id ="${user.id}"
						 $("#edit-id").val(data.activity.id);
						 $("#edit-marketActivityOwner").val(id);
						 $("#edit-marketActivityName").val(data.activity.name);
						 $("#edit-startTime").val(data.activity.startDate);
						 $("#edit-endTime").val(data.activity.endDate);
						 $("#edit-cost").val(data.activity.cost);
						 $("#edit-describe").val(data.activity.description);
						 $("#editActivityModal").modal("show");
					 }
				 })
			 }
		 })

		 $("#updateActivityBtn").click(function () {
			 var name =$.trim($("#edit-marketActivityName").val());
			 var cost=$.trim($("#edit-cost").val());
			 var description=$.trim($("#edit-describe").val());
			 if(name==""){
				 alert("名称不能为空")
				 return false
			 }
			 $.ajax({

				 url : "workbench/activity/updateActivity.do",
				 data : {
				 	 "id":$("#edit-id").val(),
					 "owner":$.trim($("#edit-Owner").val()),
					 "name":name,
					 "startDate":$.trim($("#edit-startTime").val()),
					 "endDate":$.trim($("#edit-endTime").val()),
					 "cost":cost,
					 "description":description,
				 },
				 type : "post",
				 dataType : "json",
				 success : function (data) {
				 	if(data){
				 		alert("更新成功")
						$("#editActivityModal").modal("hide");
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage'),$("#activityPage").bs_pagination('getOption', 'rowsPerPage'))
					}else {
				 		alert("更新失败")
					}

				 }
			 })


		 })

	 })



	function pageList(pageNo,pageSize) {

		$("#searchActivityName").val($.trim($("#hidden-name").val()));
		$("#searchActivityOwner").val($.trim($("#hidden-owner").val()));
		$("#searchActivityStartTime").val($.trim($("#hidden-startDate").val()));
		$("#searchActivityEndTime").val($.trim($("#hidden-endDate").val()));

			$.ajax({
		        url : "workbench/activity/pageActivity.do",
				data : {
					"pageNo" : pageNo,
					"pageSize" : pageSize,
					"name":$.trim($("#searchActivityName").val()),
					"owner":$.trim($("#searchActivityOwner").val()),
					"startDate":$.trim($("#searchActivityStartTime").val()),
					"endDate":$.trim($("#searchActivityEndTime").val())
				},
				type : "get",
				dataType : "json",
				success : function (data) {
					var html ="";
					$.each(data.datalist,function (i,n) {
						html +="<tr class='active'>";
						html +='<td><input type="checkbox" name="xz" value='+n.id+' /></td>';
						html +='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>'
						html +='<td>'+n.owner+'</td>'
						html +='<td>'+n.startDate+'</td>'
						html +='<td>'+n.endDate+'</td>'
						html +='</tr>'
					});
					$("#activityBody").html(html);



					//alert(data.total);
					//alert(data.datalist);
				   /* <tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
					<td>zhangsan</td>
					<td>2020-10-10</td>
					<td>2020-10-20</td>
					</tr>*/
		var totalPages=data.total%pageSize==0?data.total/pageSize:data.total/pageSize+1;


		$("#activityPage").bs_pagination({
			currentPage: pageNo, // 页码
			rowsPerPage: pageSize, // 每页显示的记录条数
			maxRowsPerPage: 20, // 每页最多显示的记录条数
			totalPages: totalPages, // 总页数
			totalRows: data.total, // 总记录条数

			visiblePageLinks: 3, // 显示几个卡片

			showGoToPage: true,
			showRowsPerPage: true,
			showRowsInfo: true,
			showRowsDefaultInfo: true,

			onChangePage : function(event, data){
				pageList(data.currentPage , data.rowsPerPage);
			}
		});
	}
		})
	}




	
</script>
</head>
<body>
    <input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id ="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-Owner">
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime"  readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveActivityBtn" class="btn btn-primary" >保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id" />
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" >
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime" readonly >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control"  id="searchActivityName"  type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="searchActivityOwner" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="searchActivityStartTime"  readonly/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="searchActivityEndTime" readonly>
				    </div>
				  </div>
				  
				  <button type="button" id="searchActivityBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">

					</tbody>
				</table>
			</div>
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>