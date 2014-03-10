from django.template import loader,Context  
from  django.shortcuts  import  render_to_response
from django.http import HttpResponse
from cer_manager.cer_manager.models import DbCertificate 
import MySQLdb

def cer_list(request):
	posts = DbCertificate.objects.all()
	t = loader.get_template("index.html")
	c = Context({'posts':posts})
	return HttpResponse(t.render(c))
def insert(request,param1):
	t = loader.get_template("canshu.html")
	c = Context({'canshu':param1})
	return HttpResponse(t.render(c))
def ip_insert(request):
    return render_to_response('ip_insert.html')

def test(request):
    return render_to_response('test.html')

def modify(request,id):
    cer = DbCertificate.objects.get(id=id)
    return render_to_response("modify.html",{'cer':cer})
    
    