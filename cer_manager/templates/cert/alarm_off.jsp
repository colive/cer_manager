<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="java.util.*"%>
<%@page import="com.qq.jutil.net.*"%>
<%@page import="com.qq.jutil.data.DataPage"%>
<%@page import="com.qq.jutil.string.StringUtil" %>
<%
    String BASE_PATH = request.getContextPath();
    String RES_PATH = BASE_PATH + "/quality_report/";
    String name = NetUtil.getStringParameter(request, "name", "");
    String path = NetUtil.getStringParameter(request, "path", "");
    String id = NetUtil.getStringParameter(request, "id", "0");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>屏蔽告警</title>
    <link rel="stylesheet" href="<%=RES_PATH%>/static/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%=RES_PATH%>/static/css/bootstrap-responsive.min.css">
    <%--<link rel="stylesheet" href="<%=RES_PATH%>/static/css/base.css">--%>
    <script src="<%=RES_PATH%>/static/js/jquery.min.js"></script>
    <script src="<%=RES_PATH%>/static/js/sea.js"></script>
    <script src="<%=RES_PATH%>/static/js/base.js"></script>
    <script src="http://mqqpushadmin.3gqq.com/web_mqq_cfg_admin/static/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
        var ROOT = '<%=BASE_PATH%>'
        seajs.config({
            charset : 'utf-8',
            base : '<%=RES_PATH%>'
        })
    </script>
    <style type="text/css">
        #form1 input, #form1 select{
            width: 360px;
        }
        .alert{
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
<%@include file="/cert/inc/menu.jsp" %>
<div class="container" style="margin-top:60px;">
    <ul id="breadcrumb" class="breadcrumb" style="margin-bottom: 5px;">
        <li>
            <a href="index.jsp">证书列表</a><span class="divider">/</span>
        </li>
        <li class="active">屏蔽告警</li>
    </ul>
    <div class="inner">
        <div class="control-group">
            <label class="control-label">证书名称</label>
            <div class="controls">
                <code><%=name%></code>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">证书路径</label>
            <div class="controls">
                <code><%=path%></code>
            </div>
        </div>
        <div class="form-actions">
            <button type="button" class="btn btn-primary" id="off">屏蔽告警状态</button>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        $('#off').on('click', function(e){
            if(confirm('是否屏蔽告警七天')){
                $.get('http://node.server.com/cert/alarmOff',{id:'<%=id%>'}, function(e){
                    if(e&& e.result==0){
                        alert('屏蔽告警成功')
                        location.href = 'index.jsp'
                    }else{
                        alert('操作失败')
                    }
                })
            }
        })
    })
</script>