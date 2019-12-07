## 模块相关

- es6 的模块设计是尽量的静态化，在编译时就能确定模块的依赖关系，以及输入和输出的变量
- CommonJS 只能在运行时确定模块依赖关系



### ES6 中的 module

moduleA.js
``` javascript
console.log('加载 moduleA')

export function sayHello(name) {
    console.log("Hello " + name)
}

export var firstName = 'Jackson'
``` 

moduleB.js
``` javascript
function multiply(a, b) {
    return a * b
}

// 默认输入模块，只能设置一个
export default {
    multiply
}
```

import 使用

``` javascript
import moudleB from './moduleB.js'

moudleB.multiply(10, 20)


import { firstName, sayHello } from './moduleA.js';

sayHello("Peter")
```

在浏览器中使用 es6 module

``` html
<script src="js/module/module.js" type="module"></script>
```

### node 中使用的 module CommonJS

CommonJS 模块就是对象，输入时必须查找对象的属性



export 
``` javascript
module.exports.test = () => console.log('test moudle');
module.exports.firstName = 'Peter';
```

require
``` javascript
const cert = require('./utils/cert.js');
cert.test()
```


### 参考

- http://es6.ruanyifeng.com/#docs/module
- https://github.com/mqyqingfeng/Blog/issues/108
- http://nodejs.cn/api/modules.html