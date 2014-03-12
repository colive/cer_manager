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
	if form.is_valid():
		cer_info = form.cleaned_data
        name = cer_info['name']
         
    else:
        form = ContactForm()
    return render_to_response('insert.html', {'form': form})

    
    
