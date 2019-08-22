---
title: cloudflare小工具-用来清理cdn的cache
date: 2019-8-22
tags: PYTHON
categories: CODE
---

> **顾名思义，用来清理cloudflare免费CDN缓存的，调用的是整站缓存删除的接口。


``` javascript
#encodeing:utf-8
'''
@author:PAINCLOWN-ZZJ

cloudflare小工具
用来清理cdn的cache
'''

import requests
import json

#预留cookies登录方法
class CFCookies:
    def __init__(self , user, passwd):
        self.user = user
        self.passwd = passwd
        self.cookies = ''
    def getCookies(self):
        pass

#用token和zoneID来使用api
class CFAuth:
    def __init__(self, authEmail ,authKey , zoneID):
        self.zoneID = zoneID
        self.authEmail = authEmail
        self.authKey = authKey
    def returnConfig(self):
        authApi = 'https://api.cloudflare.com/client/v4/zones/%s/' % self.zoneID
        return  (authApi , self.authEmail , self.authKey)


class CFCache:
    def __init__(self,config):
        self.config = config
        self.purgeEverythingApi = '%spurge_cache' % (self.config[0])
        self.PE = ''
        self.headers = {'X-Auth-Email':self.config[1],'X-Auth-Key':self.config[2],'Content-Type':'application/json'}
        self.postData = {"purge_everything":True}
    def purgeEverything(self):
        self.PE = requests.post(self.purgeEverythingApi ,json=self.postData,headers = self.headers)
        PEDict = json.loads(self.PE.text)
        if PEDict["success"]:
            print('成功清理%s' % PEDict["result"]["id"])
        else:
            print('没有成功清理!%s' % PEDict["errors"])


def main():
    email = '邮箱'
    authKey = 'token'
    zoneID = 'zoneID'
    config = CFAuth(email , authKey , zoneID)
    CFCache(config.returnConfig()).purgeEverything()

if __name__ == "__main__":
    main()

```
