from django import newforms as forms

class ContactForm(forms.Form):
	name = forms.CharField(required=True)
    证书路径 = forms.CharField(required=True)
    Server = forms.CharField(required=True)
    MD5 = forms.CharField(required=True)
    生效时间 = forms.CharField(required=True)
    过期时间 = forms.CharField(required=True)
    负责人 = forms.CharField(required=True)
    告警状态 = forms.CharField(required=True)
    关注人 = forms.CharField(required=True)
    模块ID = forms.IntegerField(required=True)
    def clean_info(self):
        name = self.cleaned_data['证书名称']	
        return message