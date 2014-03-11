from django import newforms as forms

class ContactForm(forms.Form):
    name = forms.CharField(required=True,label = "证书名称")
    path = forms.CharField(required=True,label = "证书路径")
    Server = forms.CharField(required=True,label = "Server")
    md5 = forms.CharField(required=True,label = "MD5")
    start_date = forms.CharField(required=True,label = "生效时间")
    end_date = forms.CharField(required=True,label = "过期时间")
    server_dev = forms.CharField(required=True,label = "负责人")
    alarm_status = forms.CharField(required=True,label = "告警状态")
    attention = forms.CharField(required=True,label = "关注人")
    server_id = forms.IntegerField(required=True,label = "模块ID")
    '''
    def clean_info(self):
        name = self.cleaned_data['证书名称']	
        return message
        '''