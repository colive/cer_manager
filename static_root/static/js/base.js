;~function(W, D, $){
    !W.console && (W.console = {log:function(){}})

    if(!Object.keys){
        Object.keys = function(obj){
            var ret = []
            for(var key in obj){
                ret.push(key)
            }
            return ret
        }
    }
    if(!Array.prototype.forEach){
        Array.prototype.forEach = function(func){
            for(var i =0;i<this.length;i++){
                func(this[i], i)
            }
        }
    }
    /* inner utils */
    var loopObject = function(target,func){
        Object.keys(target).forEach(function(key){
            func(key, target[key])
        })
    }

    /* validate */
    var validate  = {}, validateRegex = {
        IP :  /^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})$/i,
        Base64 : /[^a-zA-Z0-9\/\+=]/i,
        Email : /^[a-zA-Z0-9.!#$%&amp;'*+-/=?\^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/,
        Alpha : /^[a-z]+$/i,//字母
        AlphaOrNumeric : /^[a-z0-9]+$/i,//字母或纯数字
        Numeric : /^[0-9]+$/,//纯数字
        Positive : /^[1-9][0-9]*$/i,//正整数
        Negative : /^\-[1-9][0-9]*$/i,//负整数
        Number : /^\-?[0-9]*\.?[0-9]+$/,//数字
        Int : /^\-?[0-9]+$/,//整数
        Natural : /^[0-9]+$/i//自然数
    }
    loopObject(validateRegex, function(key,value){
        validate['is'+key] = function(target){
            if(typeof target != 'string')
                return false
            return value.test(target)
        }
    })

    /* cookie */
    var cookie = {
        get: function(name) {
            var c = D.cookie.match(new RegExp('(^|;)\\s*' + name + '=([^;\\s]*)'))
            return ((c && c.length >= 3) ? decodeURIComponent(c[2]) : null)
        },
        set: function(name, value, options) {
            var days = options.days, path = options.path, domain = options.domain, secure = options.secure
            if (days) {
                var d = new Date();
                d.setTime(d.getTime() + (days * 8.64e7)); // now + days in milliseconds
            }
            D.cookie = name + '=' + encodeURIComponent(value) + (days ? ('; expires=' + d.toGMTString()) : '') + '; path=' + (path || '/') + (domain ? ('; domain=' + domain) : '') + (secure ? '; secure' : '')
        },
        remove: function(name, path, domain) {
            this.set(name, '', -1, {path:path, domain:domain}) // sets expiry to now - 1 day
        }
    }

    /* 表单加强功能 */
    var form = {
        //ajax提交数据
        ajax : function(node, options){
            node = $(node)
            node.on('submit', function(e){
                e.preventDefault()
                e.stopPropagation()
                var checked = options.check?options.check():true
                if(!checked)
                    return
                var url = options.url || node.attr('action')
                $.ajax({
                    url : url + (url.indexOf('?')==-1?'?':'&') + $(node).serialize(),
                    type : 'GET',
                    dataType : 'json',
                    success : function(json){
                        options.success && options.success.call(this, json)
                    },
                    error : function(xhr){
                        options.error && options.error.call(this, xhr)
                    }
                })
            })
            return node
        },
        //给表单自动赋值，json数据的字段名与表单的name必须保持一致
        assign : function(form, val, except){
            loopObject(val, function(key, value){
                if($.isArray(except) && except.indexOf(key)>-1)
                    return
                var nodes = form.find('[name="' + key + '"]')
                if(nodes.length == 1){
                    nodes.val(value)
                }else if(nodes.length > 1){
                    //radio, checkbox
                    nodes.filter('[value="' + value + '"]').attr('checked', '')
                }
            })
        }
    }

    W.xLib = {
        validate : validate,
        cookie : cookie,
        $form : form
    }
}(window, document, jQuery)