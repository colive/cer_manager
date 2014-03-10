<%
    String ROOT_PATH_ = request.getContextPath();
%>
<style type="text/css">
    .overflow{
        overflow:hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
        max-width: 200px;
    }
    .container,#header .container{
        width: 90%;
    }
    .star{
        color: red;
    }
</style>
<div id="header" class="navbar navbar-inverse navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container">
		<button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>
		<a class="brand" href="<%=ROOT_PATH_ %>/cert/index.jsp">证书管理系统</a>
		<div class="nav-collapse collapse">
			<ul class="nav">
				<li>
					<a href="<%=ROOT_PATH_ %>/cert/index.jsp">证书列表</a>
				</li>
                <li>
                    <a href="<%=ROOT_PATH_ %>/cert/cert_insert.jsp">添加证书</a>
                </li>
                <li>
                    <a href="<%=ROOT_PATH_ %>/cert/ip_insert.jsp">添加IP</a>
                </li>
                <li>
                    <a href="<%=ROOT_PATH_ %>/cert/downloads.jsp">下载文件</a>
                </li>
			</ul>
            <span style="line-height: 42px;float: right;color:#fff;">系统负责人：fishtan,simongfxu,colivezhang</span>
		</div>
    </div>
  </div>
</div>
<ul id="share-menu" class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu"></ul>
<div id="loading-indicator-overlay"><div id="loading-indicator"></div></div>

<script type="text/plain" id="grid_skeleton">
    <#if(enablePanel){#>
        <div class="well">
            <div class="query-operations">
                <#if(buttons.edit){#>
                    <a class="btn" href="#" data-attr="edit"><i class="icon-pencil"></i>批量编辑</a>
                    <#}#>
                        <#if(buttons.delete){#>
                            <a class="btn" href="#" data-attr="delete"><i class="icon-trash"></i>批量删除</a>
                            <#}#>
                                <#if(buttons.add){#>
                                    <a class="btn" href="#" data-attr="add"><i class="icon-plus"></i>新增一行</a>
                                    <#}#>
                                        <#if(buttons.approve){#>
                                            <a class="btn" href="#" data-attr="approve"><i class="icon-ok"></i>批量通过</a>
                                            <a class="btn" href="#" data-attr="reject"><i class="icon-ban-circle"></i>批量拒绝</a>
                                            <#}#>
                                                <#if(buttons.filter){#>
                                                    <a class="btn" href="javascript:;" data-attr="filter"><i class="icon-filter"></i>过滤</a>
                                                    <#}#>
            </div>
            <div class="query-form-container">
                <#if(buttons.filter){#>
                    <form method="post" action="<#=url#>">
                        <#=queryHTML#>
                            <div class="form-actions">
                                <button class="btn btn-primary" type="submit"><i class="icon-search icon-white"></i>查询</button>
                                <button class="btn" type="reset">清空</button>
                                <span style="margin:0 10px;">或者</span>
                                <a href="javascript:;" onclick="$(this).parents('.query-form-container').slideToggle(200)">关闭</a>
                            </div>
                    </form>
                    <#}#>
            </div>
            <#if(buttons.edit){#>
                <div class="edit-form-container">
                    <form action="<#=buttons.edit#>" method="post">
                        <#=editHTML#>
                            <div class="form-actions">
                                <button class="btn btn-primary" type="submit"><i class="icon-search icon-white"></i>保存</button>
                                <button class="btn" type="reset">清空</button>
                                <span style="margin:0 10px;">或者</span>
                                <a href="javascript:;" onclick="$(this).parents('.edit-form-container').slideToggle(200)">关闭</a>
                            </div>
                    </form>
                </div>
                <#}#>
        </div>
        <#}#>

            <table class="table table-bordered table-striped table-hover">
                <thead>
                <#for(var i =0;i<headers.length;i++){#>
                <th><#=headers[i]#></th>
                <#}#>
                </thead>
                <tbody></tbody>
                <tfoot></tfoot>
            </table>
            <div class="pagination"></div>
</script>
