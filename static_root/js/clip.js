/**
 * 使用方式
 * ./phantomjs clip.js "http://alexouyang.kf0309.3g.qq.com/web_mqq_admin/quality_report/charts.jsp?reportid=44&mail=1&part=0" "../report"
 * 说明
 * 千万注意phantomjs的版本，低版本没有使用CommonJS规范，参数索引获取也不同
 */
var width = 1200
var get_query_string_object = function(str){
    if(!str)return {}
    var obj = {}, pList = str.split("&"), len = pList.length
    for(var i = 0; i < len; i++){
        var p = pList[i], pl = p.split("=")
        obj[pl[0]] = pl[1]
    }
    return obj
}
Array.prototype.forEach = function(func){
    for(var i =0;i<this.length;i++){
        func(this[i], i)
    }
}
var url = phantom.args[0], dir =   phantom.args[1] || '.', params = get_query_string_object(url.split('?')[1]), date =  params.statis_day, indexArray = new Array()
indexArray.length = 6
if(!date){
    date = new Date(Date.now()-24*3600*1000)
    var year = date.getFullYear(), month = date.getMonth() + 1, day = date.getDate()
    month = month<=9?'0'+month:month
    day =  day<=9?'0'+day:day
    date = [year, month, day].join('')
}
if(url && url.indexOf('http://') == 0){
    var page = new WebPage()
    page.viewportSize = { width: width, height: 9999 };
    page.open(url, function(status) {
        var height = page.evaluate(function(){
            return document.documentElement.offsetHeight
        })
        var filename = dir +'/' + date + '_' + params.reportid + '_' + params.part + '.png'
        page.clipRect = { top: 0, left: 0, width: width, height: height }
        page.render(filename)
        console.log(filename + ' has been clipped')
        phantom.exit()
    })
}else{
    console.log('invalid url, check arguments')
    phantom.exit()
}