from django.conf.urls import patterns, include, url
from django.conf import settings
from cer_manager.views import *

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'cer_manager.views.home', name='home'),
    # url(r'^cer_manager/', include('cer_manager.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
     url(r'^index/$', cer_list),
     url(r'^canshu/(.+)/$',insert),
     url(r'^test/$',test),
     url(r'^insert/$',ip_insert),
     url(r'^modify/(.+)/$',modify),
     url('^css/(?P<path>.*)$','django.views.static.serve',{'document_root':settings.STATIC_ROOT_CSS}),
     url('^js/(?P<path>.*)$','django.views.static.serve',{'document_root':settings.STATIC_ROOT_JS}), 
)
