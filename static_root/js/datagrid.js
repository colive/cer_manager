/**
 * 基于jQuery + artTemplate的表格插件
 * User: simongfxu
 * Date: 13-3-27
 * Time: 下午1:20
 */
define(function(require){
    require('static/css/grid.css')
    require('static/js/jquery.pagination.js')
    require('static/js/template.min.js')

    /**
     * ready用于实现grid的基本骨架完成以后的初始化工作，比如增加新的操作按钮等
     * start用于在发起请求之前对grid进行一些操作，通常用于修改查询面板
     * data用于修改返回的json数据方便在模版中使用，通常用于权限控制和表单字段转换
     * load用于在table的数据完全初始化后进行一些最后的操作
     * start,data,load事件每次request都会执行一次，而ready只在会在实例化的时候执行一次
     * 对于每一次请求，事件执行的先后顺序：start -> data -> load 或者 start -> error
     */
    var supportEvent = ['ready', 'start', 'data', 'load', 'error'], defaultEvents = {}
    $.each(supportEvent, function(index, item){
        defaultEvents[item] = function(){
            console.log('**** event:' + item + ' ****', arguments)
        }
    })

    //验证常用配置是否正确：ajax请求地址、grid骨架、tbody模版、表头与模版的一致性
    var checkOptions = function(options){
        if(!options.url)
            throw new Error('arguments error : url missed')
        if($('#'+options.skeleton).length!=1)
            throw new Error('arguments error : skeleton missed')
        var template = $('#' + options.tbodyTemplate)
        if(template.length != 1)
            throw new Error('template error : template missed')
        //需要移除模版中的注释
        if(!options.headers.length || options.headers.length != template.html().replace(/<!--.*-->/g,'').replace(/<%--.*--%>/g,'').match(/<td.*>/gi).length)
            throw new Error('template error : header and template columns length is not the same')
        //如果没有主动禁用查询功能则会进行一次查找操作，根据是否找到模版节点来设置查询表单的内容
        if(options.queryTemplate != false){
            var q = $('#' + options.queryTemplate)
            options.buttons.filter = q.length == 1
            options.queryHTML = q.html()
        }else{
            options.buttons.filter = false
            options.queryHTML = ''
        }

        if(options.editTemplate != false){
            var q = $('#' + options.editTemplate)
            options.editHTML = q.length==1?q.html():''
        }else{
            options.buttons.edit = false
            options.editHTML = ''
        }
    }


    /**
     * 每一次请求成功后根据json数据组织table的DOM
     * @param grid
     * @param json
     */
    var createTableFromJSON = function(grid, json){
        var table = grid._node.children().filter('table'), options = grid._options
        options.events.data.call(grid, json)
        if(json[options.jsonFieldName] && json[options.jsonFieldName].length){
            var list = json[options.jsonFieldName]
            table.children().filter('tbody').html(template(options.tbodyTemplate, json))
        }else{
            table.children().filter('tbody').html('<tr><td colspan="' + options.headers.length +'"><p style="text-align:center;"><strong>暂时没有相关数据</strong></p></td></tr>')
        }
        options.events.load.call(grid, json)
    }

    function Grid(div, options){
        div = typeof  div == 'string'?$('#'+div):$(div)
        if(!div || div.length!=1)
            throw new Error('grid container error, check arguments')
        var opts = $.extend({
            url : '', //ajax 请求地址
            headers : [],//表头
            events : defaultEvents,
            enablePanel : true,
            skeleton : 'grid_skeleton', //组件骨架，在header.jsp中
            tbodyTemplate : div.attr('id') + '_tbody_template',
            queryTemplate : div.attr('id') + '_query_template',
            editTemplate  : div.attr('id') + '_edit_template',
            jsonFieldName : 'info',  //json数据列
            pageSizeName : 'pageSize',
            pageNoName : 'pageNo',
            pageSize : 20,
            params : {} //请求额外附带的参数
        },options)
        opts.buttons = $.extend({
            //是否展示编辑按钮
            edit : true,
            //是否展示批量删除
            delete : true,
            //是否展示批量审批按钮
            approve : false,
            reject : false,
            filter : true
        }, options.buttons)
        var that = this
        this._node = div
        this._options = opts
        checkOptions(this._options)
        //DOM初始化
        div.html(template(opts.skeleton, opts))
        //如果开启顶部面板
        if(opts.enablePanel){
            var getCheckboxValues = function(checkboxes){
                var ids = []
                if(checkboxes.length <1){
                    return ids
                }
                checkboxes.each(function(){
                    ids.push(this.value)
                })
                return ids
            }
            var runBatch = function(url){
                var checkboxes = div.find('tbody input:checked'), params = {}, name = checkboxes.attr('name')
                if(!checkboxes.length)
                    return
                if(!name)
                    throw new Error('unset checkbox name attribute')
                params[name] = getCheckboxValues(checkboxes)
                $.post(url, params, function(json){
                    json = $.parseJSON(json) || {}
                    if(json && json.result == 0){
                        that.refresh()
                        alert('操作成功！')
                    }else{
                        alert('操作失败！' + json.msg)
                    }
                })
            }
            //启用查询组件
            if(opts.buttons.filter){
                div.find('[data-attr=filter]').on('click', function(){
                    div.find('.query-operations').siblings(':not(.query-form-container)').hide()
                    div.find('.query-form-container').slideToggle(200)
                })
                div.find('.query-form-container form').on('submit', function(e){
                    e.preventDefault()
                    opts.events.start.call(that, e)
                    that.request(0)
                })
            }
            //启用批量编辑
            if(opts.buttons.edit){
                div.find('[data-attr=edit]').on('click', function(){
                    div.find('.query-operations').siblings(':not(.edit-form-container)').hide()
                    div.find('.edit-form-container').slideToggle(200)
                })
                div.find('.edit-form-container form').on('submit', function(e){
                    e.preventDefault()
                    var url =  opts.buttons.edit
                    if(typeof url == 'string'){
                        runBatch(url + (url.indexOf('?')>-1?'&':'?') + $(this).serialize())
                    }else{
                        throw new Error('config error, edit url must be a string.')
                    }
                })
            }
            //全选、反选
            div.find('thead input').on('click', function(e){
                $(this).parents('thead').siblings('tbody').find('input:checkbox').prop('checked', $(this).prop('checked'))
            })
            var buttons = opts.buttons
            Object.keys(buttons).forEach(function(key){
                if(key == 'edit' || key == 'filter')
                    return
                var keyType = typeof buttons[key]
                //指定了ajax接口
                if(keyType == 'string'){
                    div.find('[data-attr="' + key + '"]').on('click', function(e){
                        runBatch(buttons[key])
                    })
                    //如果指定为特定的函数
                }else if(keyType == 'function'){
                    div.find('[data-attr="' + key + '"]').on('click', function(e){
                        buttons[key].call(this, e, getCheckboxValues(div.find('tbody input:checked')))
                    })
                }
            })
        }
        //如果此时还没有绑定ready事件，则在bind后立即执行
        if(options.events && typeof options.events.ready == 'function')
            options.events.ready.call(this)
    }

    Grid.prototype.request = function(pageNo){
        var pager = this._node.find('.pagination'), form = this._node.find('.query-form-container form'), options = this._options, that = this
        that.currentPageNo = pageNo
        options.params[options.pageNoName] = pageNo + 1
        options.params[options.pageSizeName] = options.pageSize
        $.ajax({
            url : options.url + (options.url.indexOf('?')>-1?'&':'?') + form.serialize(),
            dataType : 'json',
            type : 'GET',
            data : options.params,
            crossDomain : true,
            success : function(json){
                createTableFromJSON(that,json)
                pager.pagination(json.total, {
                    next_text : '>>',
                    prev_text : '<<',
                    items_per_page : options.pageSize,
                    show_if_single_page : false,
                    ellipse_text : '...',
                    load_first_page : false,
                    num_edge_entries : 1,
                    ajaxCallback : function(index){
                        that.request(index)
                    }
                })
                pager.trigger('setPage', pageNo)
            },
            error : function(xhr){
                options.events.error.call(that, xhr)
            }
        })
    }

    //设置请求POST额外传输的数据
    Grid.prototype.params = function(data){
        this._options.params = $.extend(this._options.params, data)
    }
    //绑定相关事件
    Grid.prototype.bind = function(evtName, func){
        if($.inArray(evtName, supportEvent)>-1){
            this._options.events[evtName] = func
            if(evtName == 'ready'){
                func.call(this)
            }
        }else if(evtName && typeof  evtName == 'object'){
            for(var key in evtName){
                this.bind(key, evtName[key])
            }
        }
    }

    Grid.prototype.getNode = function(){
        return this._node
    }

    Grid.prototype.getOptions = function(){
        return this._options
    }

    Grid.prototype.refresh = function(){
        this.request(this.currentPageNo)
    }

    return Grid
})