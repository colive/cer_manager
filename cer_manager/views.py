from django.template import loader,Context  
from  django.shortcuts  import  render_to_response
from django.http import HttpResponse
from cer_manager.cer_manager.models import DbCertificate 
import MySQLdb
from forms import ContactForm

def cer_list(request):
	posts = DbCertificate.objects.all()
	t = loader.get_template("index.html")
	c = Context({'posts':posts})
	return HttpResponse(t.render(c))
	return HttpResponse(t.render(c))
def ip_insert(request):
    return render_to_response('ip_insert.html')

def test(request):
    return render_to_response('test.html')

def modify(request,id):
    cer = DbCertificate.objects.get(id=id)
    return render_to_response("modify.html",{'cer':cer})
'''
def insert(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            cd = form.cleaned_data   
            )
            return HttpResponseRedirect('error.html')
    else:
        form = ContactForm()
    return render_to_response('insert.html', {'form': form})
'''
def insert(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
 '''
     name = forms.CharField(required=True,label = u'证书名称')
    path = forms.CharField(required=True,label = u'证书路径')
    Server = forms.CharField(required=True,label = u'Server')
    md5 = forms.CharField(required=True,label = "MD5")
    start_date = forms.CharField(required=True,label = u'生效时间')
    end_date = forms.CharField(required=True,label = u'过期时间')
    server_dev = forms.CharField(required=True,label = u'负责人')
    alarm_status = forms.CharField(required=True,label = u'告警状态')
    attention = forms.CharField(required=True,label = u"关注人")
    server_id = forms.IntegerField(required=True,label = u'模块ID')
    '''       
	if form.is_valid():
		cer_info = form.cleaned_data
        name = cer_info['name']
        path = cer_info['path']
        Server = cer_info['Server']
        md5 = cer_info['md5']
        start_date = cer_info['start_date']
        end_date = cer_info['end_date']
        server_dev = cer_info['server_dev']
        alarm_status = cer_info['alarm_status']
        attention = cer_info['attention']
        server_id = cer_info['server_id']
        cer_object = DbCertificate(name = name,path = path,Server = Server ,md5 = md5 
            start_date = start_date,end_date = end_date,server_dev = server_dev
            alarm_status = alarm_status,attention = attention,server_id = server_id)
        cer_object.save()
    else:
        form = ContactForm()
    return render_to_response('insert.html', {'form': form})

    
    
