### json的使用

### json 转 js的object
``` javascript
var json = '{"name": "Peter", "sex": "male"}';
var obj2 = eval('(' + json + ')');

var obj3 = JSON.parse(json);

```

### js的object 转 json
```
var json = '{"name": "Peter", "sex": "male"}';
var str2 = JSON.stringify(obj);
```	