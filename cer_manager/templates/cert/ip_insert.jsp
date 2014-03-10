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
    Boolean isEdit = path!=null && path.length()>0;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>添加IP</title>
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
        #form1 input, #form1 select{
            width: 360px;
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
        <li class="active">添加IP</li>
    </ul>
    <div class="inner">
        <form class="form-horizontal" action="http://node.server.com/cert/svrip/insert" method="post" id="form1">
            <div class="control-group">
                <label class="control-label">IP地址<span class="star">*</span></label>
                <div class="controls">
                    <input type="text" name="ip" value=""  required="true">
                    <button class="btn btn-info btn-small" onclick="querySvrIP()" type="button">查询</button>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">模块ID<span class="star">*</span></label>
                <div class="controls">
                    <input type="text" name="server_id" value=""  required="true" maxlength="60">
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">立即添加</button>
                <button type="button" class="btn" onclick="history.go(-1)">返回</button>
            </div>
        </form>
        <div id="well" class="well" style="display: none;">
            <strong>与此IP地址相关的证书信息</strong>
            <div id="results"></div>
        </div>
    </div>
</div>
<script type="text/javascript">
    function querySvrIP(){
        $.get('http://node.server.com/cert/svrip/query', {ip: $.trim($('#form1 [name=ip]').val())}, function(e){
            if(e&&e!='fail'){
                var info = e.split('\n'), str = []
                info.forEach(function(line){
                    str.push('<code>'+line+'</code>')
                })
                $('#results').html(str.join('<br>'))
                $('#well').show()
            }else{
                alert('没有找到相关结果')
            }
        })
    }
    $(function(){
        xLib.$form.ajax($('#form1'), {
            check : function(){
                if(!xLib.validate.isIP($.trim($('#form1 [name=ip]').val()))){
                    alert('请检查IP地址')
                    return false
                }
                if(!$('#form1 [name=server_id]').val()){
                    alert('模块ID不能为空')
                    return false
                }
                return true
            },
            success : function(json){
                if(json && json.result == 0){
                    alert('操作成功')
                }else{
                    alert('操作失败！' + json&&json.msg)
                }
            }
        })
    })
</script>