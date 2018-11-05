




### request post的Content-Type的设置

#### application/json

post参数以json格式提交

```
:method: POST
:scheme: https
:path: /xuntong/ecLite/convers/v4/groupList
:authority: www.yunzhijia.com
cookie: gl=7b0f2170-0553-4ac4-8b19-f6c271bbc86c
accept: */*
content-type: application/json
accept-language: zh-CN
content-length: 57
x-request-id: 0F02D601-E112-4C0F-8C74-054BC8F8F328
opentoken: 4b3b45a4fe38f22e4cd62e665015bb96
user-agent: 10200/10.1.1;iOS 12.1;Apple;iPhone10,2;102;deviceId:72c9209e-3c13-4987-814f-e0843bfd0f5b;deviceName:quding;clientId:10200;os:iOS 12.1;brand:Apple;model:iPhone10,2;lang:zh-CN;fontNum:0
accept-encoding: br, gzip, deflate

{"useMS":true,"lastUpdateTime":"2018-11-03 14:44:20.135"}
```


#### application/x-www-form-urlencoded

post参数以表单形式提交

```
:method: POST
:scheme: https
:path: /xuntong/ecLite/convers/user/getStatus.action
:authority: www.yunzhijia.com
cookie: gl=7b0f2170-0553-4ac4-8b19-f6c271bbc86c
accept: */*
content-type: application/x-www-form-urlencoded
accept-language: zh-CN
content-length: 15
x-request-id: 69DF7F44-D0DE-453F-ACD7-2645DE9DEB1B
opentoken: 4b3b45a4fe38f22e4cd62e665015bb96
user-agent: 10200/10.1.1;iOS 12.1;Apple;iPhone10,2;102;deviceId:72c9209e-3c13-4987-814f-e0843bfd0f5b;deviceName:quding;clientId:10200;os:iOS 12.1;brand:Apple;model:iPhone10,2;lang:zh-CN;fontNum:0
accept-encoding: br, gzip, deflate

name=mobilePush&latitude=22.53429633246528&longitude=113.9557994249132
```

### response 的返回数据
```
:status: 200
server: openresty
date: Sat, 03 Nov 2018 06:47:07 GMT
content-type: application/json;charset=UTF-8
vary: Accept-Encoding
strict-transport-security: max-age=15768000
strict-transport-security: max-age=0
content-encoding: gzip

{"data":null,"errorMessage":"验证用户失败","success":false,"errorCode":10008}
```