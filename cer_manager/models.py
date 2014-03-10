# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#     * Rearrange models' order
#     * Make sure each model has one field with primary_key=True
# Feel free to rename the models, but don't rename db_table values or field names.
#
# Also note: You'll have to insert the output of 'django-admin.py sqlcustom [appname]'
# into your database.

from django.db import models

class DbCertificate(models.Model):
    name = models.CharField(max_length=96)
    path = models.CharField(max_length=768, blank=True)
    cer_server = models.CharField(max_length=768, blank=True)
    md5 = models.CharField(max_length=108, blank=True)
    start_date = models.CharField(max_length=384, blank=True)
    end_date = models.CharField(max_length=384, blank=True)
    server_dev = models.CharField(max_length=384, blank=True)
    alarm_status = models.CharField(max_length=12, blank=True)
    attention = models.CharField(max_length=384, blank=True)
    server_id = models.IntegerField()
    append = models.CharField(max_length=24, blank=True)
    last_modified = models.IntegerField(null=True, blank=True)
    id = models.IntegerField(primary_key=True)
    class Meta:
        db_table = u'db_certificate'

class DbServerIp(models.Model):
    ip = models.CharField(max_length=48, primary_key=True)
    server_id = models.IntegerField(primary_key=True)
    append = models.CharField(max_length=96, blank=True)
    class Meta:
        db_table = u'db_server_ip'

