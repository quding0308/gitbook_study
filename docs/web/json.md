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


JSON 类型

``` JavaScript
JavaScript Object Notation

null

true/false  Boolean 

123   Number

“Peter”  String(使用双引号)

{“key”:"value”}  Object

[a,b,c]    Array

// JSON 语法
// JSON 中使用双引号
{
    "name": "Peter",
    "age": 21,
    "aa": null,
    "bb": true,
    "cc": false,
    "dd": {
        "a": "b"
    },
    "ee": [
        1,
        {
            "a": 12,
            "b": 34
        }
    ]
}
```