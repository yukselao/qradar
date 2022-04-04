
#!/usr/bin/python

'''
Author: aliokan.yuksel@ibm.com
Date: 2019-06-27
'''



import requests
import sys
import warnings
import re
warnings.filterwarnings('ignore')


token="929fd1d4-693c-41c2-9033-a714a5f5e1dc"
server='https://10.10.2.10/api'
header={}
header['SEC'] = token
header['Version']= "16.0"
header['Accept'] = "application/json"
header["Content-Type"]= "application/json"

url='/siem/offenses/' + sys.argv[1]
serverurl=server+url
req=requests.get(serverurl,headers=header,verify=False)
ret=req.json()
print(ret)



def sid2ip(sid):
        url="/siem/source_addresses/" + str(sid)
        serverurl=server+url
        req=requests.get(serverurl,headers=header,verify=False)
        ret=req.json()
        sourceip=ret["source_ip"]
        return sourceip

def rid2ip(rid):
        url="/siem/local_destination_addresses/" + str(rid)
        serverurl=server+url
        req=requests.get(serverurl,headers=header,verify=False)
        ret=req.json()
        sourceip=ret["local_destination_ip"]
        return sourceip

def isip(ip):
        excludelist=['127.0.0.1']
        if ip in excludelist:
                return False
        if re.findall(r'([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)',ip):
                return True
        else:
                return False


def getsrcip(iplist):
        for sid in iplist:
                ip=sid2ip(sid)
                if isip(ip):
                        print(ip)

def getlocaldstip(iplist):
        ips=[]
        for sid in iplist:
                ip=rid2ip(sid)
                if ip not in ips:
                        ips.append(ip)
                        if isip(ip):
                                print(ip)
print("Source IPs: ")
getsrcip(ret["source_address_ids"])

print("Local Destination IPs: ")
getlocaldstip(ret["local_destination_address_ids"])

#TODO
# 1. Get Remote IPs
# 2. Get last logged in usernames for the IP
# 3. Check if ip address communicated with critical assets


