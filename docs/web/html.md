
HyperText Markup Language

标记语言 描述内容的含义和结构
CSS 网页的展示
JavaScript 功能与行为

使用 “元素” 来定义文档结构。


## HTML Header

``` html
<head>

	<title>title123</title>

	<!-- 规定HTML的字符编码。用于 替换：
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> -->
	<meta charset="UTF-8" />

	<!-- 告诉搜索引擎 网页的关键字 -->
	<meta name="keywords" content="keywords">
	
	<!-- 告诉搜索引擎 网页的主要内容 -->
	<meta name="description" content="Free Web tutorials">
	
	<!-- 网页作者 -->
	<meta name="author" content="quding0308">

	<!-- 移动端的窗口，常用语移动端网页 -->
	<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1, user-scalable=no">
	
	<!-- 指定IE和Chrome使用最新版本渲染当前页面 -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/> 

	<!-- 页面的cache control -->
	<meta http-equiv="cache-control" content="no-cache">

	<!-- 网页过期时间 -->
	<meta http-equiv="expires" content="Sunday 26 October 2016 01:00 GMT" />

	<!-- 设置 cookie -->
	<meta http-equiv="Set-Cookie" content="name=qd">

</head>
```

## HTML TAG

``` html
<html>
<head>  // 文档的元数据
<body>

<h1>
<title>
<header>
<footer>
<nav>   // 导航栏（含有多个链接，可跳转到其他页面）
<details>
<datalist>
<article>
<section>
<p>
<div>
<span>  // 内联tag，没有特殊含义
<img>
<audio>
<video>
<canvas>
<aside> // 表示一个和其余页面内容不相关的部分
<embed> // 外部内容嵌入到文档中

tag参考：
https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element
```



#### JS操作 dom 与 CSS


Ajax 
Asynchronous JavaScript + XML（异步JavaScript和XML）