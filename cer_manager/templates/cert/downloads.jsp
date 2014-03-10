<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="java.util.*"%>
<%
    String BASE_PATH = request.getContextPath();
    String RES_PATH = BASE_PATH + "/quality_report/";
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>文件下载</title>
    <link rel="stylesheet" href="<%=RES_PATH%>/static/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%=RES_PATH%>/static/css/bootstrap-responsive.min.css">
    <script src="<%=RES_PATH%>/static/js/jquery.min.js"></script>
    <script src="<%=RES_PATH%>/static/js/sea.js"></script>
    <script src="<%=RES_PATH%>/static/js/base.js"></script>
    <script src="<%=RES_PATH%>/static/js/template.min.js"></script>
    <script type="text/javascript">
        var ROOT = '<%=BASE_PATH%>'
        seajs.config({
            charset : 'utf-8',
            base : '<%=RES_PATH%>'
        })
    </script>
    <style type="text/css">
        .well{
            margin-bottom: 2px;
        }
    </style>
</head>
<body>
<%@include file="/cert/inc/menu.jsp" %>
<div class="container" style="margin-top:60px;">
    <ul id="breadcrumb" class="breadcrumb" style="margin-bottom: 5px;">
        <li class="active">文件下载</li>
    </ul>
    <div id="file_list"></div>
</div>
<script type="text/plain" id="file_template">
    <#for(var i =0;i<info.length;i++){#>
    <div class="well well-small">
        <strong><#=info[i]#></strong>
        <a style="margin-left:20px" href="http://node.server.com/cert/download?file=<#=info[i]#>">下载</a>
    </div>
    <#}#>
</script>
<script type="text/javascript">
    $.get('http://node.server.com/cert/files', function(e){
        if(e&& e.info){
            $('#file_list').html(template('file_template', e))
        }else{
            alert('获取文件列表失败')
        }
    })
</script>