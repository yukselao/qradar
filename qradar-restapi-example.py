#!/usr/bin/python

'''
Author: aliokan.yuksel@ibm.com
Date: 2019-06-27
'''



import requests
token='c23454a2-9e8d-4eb8-8c7f-dd2655943321'
server='https://172.16.60.10/api'
header={}
header['SEC'] = token
header['Version']= "10.1"
header['Accept'] = "application/json"
header["Content-Type"]= "application/json"
#excluded type ids
excludelist=[18]

url='/config/event_sources/log_source_management/log_source_types'
serverurl=server+url
req=requests.get(serverurl,headers=header,verify=False)
types=req.json()
def gettypename(mytype):
    global types
    mtype=str(mytype)
    for tdata in types:
        if str(tdata['id'])==str(mytype):
            return tdata['name']


url='/config/event_sources/log_source_management/log_source_groups'
serverurl=server+url
req=requests.get(serverurl,headers=header,verify=False)
groups=req.json()
def getgroupname(mygroup):
    global groups
    mygroup=str(mygroup)
    for tdata in groups:
        if str(tdata['id'])==str(mygroup):
            return tdata['name']



url='/config/event_sources/log_source_management/log_sources'
serverurl=server+url
req=requests.get(serverurl,headers=header,verify=False)
result=req.text.encode('utf-8')
f=open('result.log','w')
f.write(result)
f.close()
for data in req.json():
    if data['type_id'] not in excludelist:
        url='/config/event_sources/log_source_management/log_sources/'+str(data['id'])+'?fields=group_ids'
        serverurl=server+url
        req2=requests.get(serverurl,headers=header,verify=False)
        data2=req2.json()
        print data['name']+' - Status:'+data['status']['status']
        print str(data['type_id'])+' - '+gettypename(data['type_id'])
        for groupid in data2['group_ids']:
                print getgroupname(groupid)
        print
