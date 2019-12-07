## URL


### search / query

在 url 中，search 在前，hash 在后。

* query的规定是以第一个 ? 开始，至行尾或 # 结束
* fragment以 # 为开始，行尾为结束


### hash(#) fragment

'#' 代表网页的一个位置。# 右面的字符就是该位置的标识符。

'#' 用来指导浏览器的动作，对服务器完全无用。http 请求中，会忽略掉 # 之后的字符。

改变 # 后的字符，浏览器只会滚动到相应位置，不会重新加载页面。

改变 # 后的字符，会改变浏览器的访问历史。每次改动，都会在访问历史中增加一个记录。

通过 window.location.hash 可以读写 hash 值。写入时，会滚动到指定页面（不会重载页面，但会创造一条访问历史记录）

```
window.location.hash = ''

hash 值改变后，会触发 onhashchange 事件。

window.onhashchange = function () {
    //
}
```

vue 中 hash 与 history 模式：

https://router.vuejs.org/zh/guide/essentials/history-mode.html

## 参考

- https://tools.ietf.org/html/rfc3986

