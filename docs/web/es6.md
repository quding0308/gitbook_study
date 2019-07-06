### es6

### async、await

async 表示函数里有异步操作，await表示紧跟在后面的表达式需要等待结果。

async 函数完全可以看作多个异步操作，包装成的一个 Promise 对象，而await命令就是内部then命令的语法糖。

#### 返回值

async 函数返回的 Promise 对象。await 返回的是值。

#### 异常处理：

如果 await 的 Promise 对象 reject，则 async 函数返回的 Promise 也会 reject。异常处理类比 promise.all([p1, p2, p3])。

promise.all([]) 中的多个 promise 会并发执行，但 await 的 promise 是前后依赖的。

``` javascript
function testPromise () {
    const result = asyncMethod();
    result.then(function(value) {
        console.log(value);
    }, function (error) {
        console.log(error);
    });
}

async function asyncMethod () {
    const text1 = await asynGet1()
    const result = await asynGet2(text1)

    return result
} 

async function asynGet1 () {
    const text = await new Promise(function(resolve, reject) {
        setTimeout(function () {
            resolve('text1');
            // reject('reject 失败');
        }, 3000);
    });

    return text;
}

async function asynGet2 (text1) {
    const text = await new Promise(function(resolve, reject) {
        setTimeout(function () {
            resolve(text1 + ' text2');
            // reject('reject 失败');
        }, 3000);
    });

    return text;
}
```