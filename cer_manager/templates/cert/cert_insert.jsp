<%
    String BASE_PATH = request.getContextPath();
    String RES_PATH = BASE_PATH + "/quality_report/";
    String name = NetUtil.getStringParameter(request, "name", "");
    String path = NetUtil.getStringParameter(request, "path", "");
    String id = NetUtil.getStringParameter(request, "id", "0");

    Boolean isEdit = id!=null && id.length()>0;
    com.wsd.itil.common.login.LoginInfo userInfo = (com.wsd.itil.common.login.LoginInfo) request.getSession().getAttribute("userinfo");
    String username = userInfo.getLoginName();
    Boolean isAdmin = "colivezhang".equals(username);
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>添加证书</title>
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
        <li class="active"><%=isEdit?"编辑证书":"添加证书"%></li>
    </ul>
    <div class="inner">
        <form class="form-horizontal" action="http://node.server.com/cert/insert?id=<%=id%>" method="post" id="form1">
            <div class="control-group">
                <label class="control-label">证书名称<span class="star">*</span></label>
                <div class="controls">
                    <input type="text" name="name" value=""  required="true" maxlength="60">
                    <%if(isEdit){%>
                    <input type="hidden" name="old_name" value="<%=name%>">
                    <input type="hidden" name="old_path" value="<%=path%>">
                    <%}%>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">证书路径<span class="star">*</span></label>
                <div class="controls">
                    <input type="text" name="path" value=""  required="true">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Server<span class="star">*</span></label>
                <div class="controls">
                    <input type="text" name="cer_server" value=""  required="true" maxlength="60">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">模块ID<span class="star">*</span></label>
                <div class="controls">
                    <input type="text" name="server_id" value=""  required="true" maxlength="60">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">MD5<span class="star">*</span></label>
                <div class="controls">
                    <input type="text" name="md5" value=""  required="true">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">生效时间</label>
                <div class="controls">
                    <input type="text" name="start_date" value=""  required="true" class="Wdate">
                    <div class="alert alert-info">
                        参考格式：Apr 27 11:20:30 2013 GMT
                    </div>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">过期时间<span class="star">*</span></label>
                <div class="controls">
                    <input type="text" name="end_date" value=""  required="true" class="Wdate">
                    <div class="alert alert-info">
                        参考格式：Apr 27 11:20:30 2013 GMT
                    </div>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">负责人<span class="star">*</span></label>
                <div class="controls">
                    <input type="text" name="server_dev" value=""  required="true">
                    <div class="alert alert-info">
                        多个负责人请使用半角分号;分隔
                    </div>
                </div>
            </div>
            <div class="control-group" style="display: none">
                <label class="control-label">告警状态<span class="star">*</span></label>
                <div class="controls">
                    <select name="alarm_status" id="">
                        <option value="Y" selected>Yes</option>
                        <option value="N">No</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">关注人</label>
                <div class="controls">
                    <input type="text" name="attention" value=""  required="true">
                    <div class="alert alert-info">
                        多个关注人请使用半角分号;分隔
                    </div>
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary" id="btn_save"><%=isEdit?"保存修改":"新增证书"%></button>
                <button type="button" class="btn" onclick="history.go(-1)">返回</button>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        xLib.$form.ajax($('#form1'), {
            success : function(json){
                if(json && json.result == 0){
                    alert('操作成功')
                    location.href = 'index.jsp'

                }else{
                    alert('操作失败！' + json&&json.msg)
                }
            }
        })
        if(<%=isEdit%>){
            var username = '<%=username%>'
            $.get('http://node.server.com/cert/query', {id:'<%=id%>'}, function(json){
                if(json&&json.info){
                    xLib.$form.assign($('#form1'), json.info[0])
                    if(!<%=isAdmin%>&&json.info[0].server_dev.trim().split(/,|;/).indexOf(username) == -1){
                        $('#btn_save').remove()
                        $('#form1').off('submit').find('input').attr('disabled', true)
                    }
                }else{
                    alert('查询失败！'+json.msg)
                }
            })
        }
    })
</script>
