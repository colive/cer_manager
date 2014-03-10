<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="java.util.*"%>
<%@page import="com.qq.jutil.data.*"%>
<%@page import="com.qq.jutil.string.*"%>
<%@page import="com.qq.jutil.net.*"%>
<%@page import="com.qq.jutil.data.*"%>
<%@page import="com.wsd.itil.common.login.*"%>

<%
    String BASE_PATH = request.getContextPath();
    String RES_PATH = BASE_PATH + "/quality_report/";
    com.wsd.itil.common.login.LoginInfo userInfo = (com.wsd.itil.common.login.LoginInfo) request.getSession().getAttribute("userinfo");
    String username = userInfo.getLoginName();
    Boolean isAdmin = "colivezhang".equals(username);
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>证书列表</title>
    <link rel="stylesheet" href="<%=RES_PATH%>/static/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%=RES_PATH%>/static/css/bootstrap-responsive.min.css">
    <%--<link rel="stylesheet" href="<%=RES_PATH%>/static/css/base.css">--%>
    <script src="<%=RES_PATH%>/static/js/jquery.min.js"></script>
    <script src="<%=RES_PATH%>/static/js/sea.js"></script>
    <script src="<%=RES_PATH%>/static/js/base.js"></script>
    <script type="text/javascript">
        var ROOT = '<%=BASE_PATH%>'
        seajs.config({
            charset : 'utf-8',
            base : '<%=RES_PATH%>'
        })
    </script>
    <style type="text/css">
        #grid_wrapper table{
            max-width:1200px;
            width: 1200px;
        }
        #grid_wrapper tbody td{
            font-size: 12px;
        }
        .overflow2{
            word-break: break-all;
        }
    </style>
</head>
<body>
<%@include file="/cert/inc/menu.jsp" %>
<div class="container" style="margin-top:60px;">
    <div class="well well-small">
        <a class="btn" href="cert_insert.jsp">添加证书</a>
    </div>
    <div id="grid_wrapper"></div>
</div>
<script type="text/plain" id="grid_wrapper_tbody_template">
    <#for(var i =0;i<info.length;i++){#>
    <tr>
        <td class="overflow2" style="max-width:150px;" title="<#=info[i].name||''#>"><#=info[i].name||''#></td>
        <td class="overflow2" style="max-width:100px" title="<#=info[i].server_dev||''#>"><#=info[i].server_dev||''#></td>
        <td class="overflow2" style="max-width:150px;" title="<#=info[i].end_date||''#>">
            <#= formatDateTime(info[i].end_date).content#>
            <div style="text-align:center">
                <#= formatDateTime(info[i].end_date).tip#>
            </div>
        </td>
        <td class="overflow2" style="max-width:70px"><#=info[i].server_id||''#></td>
        <td class="overflow2" style="max-width:100px;" title="<#=info[i].md5||''#>"><#=info[i].md5||''#></td>
        <td class="overflow2" style="max-width:100px;" title="<#=info[i].path||''#>"><#=info[i].path||''#></td>
        <td class="overflow2" style="max-width:80px"><#=info[i].alarm_status||''#></td>
        <td class="overflow2" style="max-width:150px;" title="<#=info[i].attention||''#>"><#=info[i].attention||''#></td>
        <td class="overflow2" style="max-width:150px;" title="<#=info[i].cer_server||''#>"><#=info[i].cer_server||''#></td>
        <td class="overflow2" style="max-width:250px;">
            <#if(<%=isAdmin%>||('<%=username%>' && info[i].server_dev.indexOf('<%=username%>')>-1 )){#>
            <a class="btn btn-mini" href="cert_insert.jsp?id=<#=info[i].id#>&name=<#=info[i].name||''#>&path=<#=info[i].path||''#>">编辑</a>
            <a class="btn btn-mini" href="javascript:;" onclick="removeItem(this, '<#=info[i].name||''#>', '<#=info[i].path||''#>', '<#=info[i].id#>')">删除</a>
            <#if(info[i].alarm_status!='N'){#>
            <a class="btn btn-mini" href="alarm_off.jsp?id=<#=info[i].id#>&name=<#=info[i].name||''#>&path=<#=info[i].path||''#>">屏蔽告警</a>
            <#}#>
            <#}else{#>
                <a class="btn btn-mini" href="cert_insert.jsp?id=<#=info[i].id#>">查看</a>
            <#}#>
        </td>
    </tr>
    <#}#>
</script>
<script type="text/javascript">
    function removeItem(a, name, path, id){
        if(confirm('确认删除此证书吗？\n名称：'+name+'\n路径：'+path)){
            $.get('http://node.server.com/cert/remove',{id:id}, function(e){
                if(e && e.result == 0){
                    alert('删除成功')
                    $(a).parents('tr').remove()
                }else{
                    alert('操作失败！'+ (e&&e.msg||''))
                }
            })
        }
    }
    seajs.use('<%=RES_PATH%>/static/js/datagrid.js', function(Grid){
        template.helper('formatDateTime', function(dtStr){
            var date, ms, delta, expiredDays,tip
            try{
                ms = Date.parse(dtStr)
                delta = ms - Date.now()
                date = new Date(ms)
                if(delta>0){
                    expiredDays = Math.floor(delta/(3600*1000*24))
                    tip = expiredDays>=1?(expiredDays+'天后到期'):'即将到期'
                    tip = '<span style="color:green">' + tip + '</span>'
                }else{
                    tip = '<span style="color:#ff0000">已经过期</span>'
                }
            }catch (e){
                return {content:'-',tip:''}
            }
            return {
                content : [date.getFullYear(),date.getMonth()+1, date.getDate()].join('-') + ' ' + [date.getHours(), date.getMinutes(), date.getSeconds()].join(':'),
                tip : tip
            }
        })

        var grid = new Grid('grid_wrapper',{
            url : 'http://node.server.com/cert/list',
            headers : ['证书名称', '负责人', '过期时间', '模块ID', 'MD5', '证书路径', '告警状态', '关注人', '所属业务', '操作'],
            pageSize:10,
            enablePanel:false
        })
        grid.request(0)
    })
</script>