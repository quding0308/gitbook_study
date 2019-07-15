## JavaScript 中对象、继承 和 原型链

### class 相关

```
class Point {
    name = 'Peter'  // 新写法，定义实例属性 与 x、y 等价
    static staticProp = '静态属性'

    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    toString() {
        return '(' + this.x + ', ' + this.y + ')';
    }

    get prop() {
        return this.name
    }

    set prop(value) {
        this.name = value
    }

    // 静态方法 不可以被实例继承
    static hellWorld() {
        //
    }
}

let p = new Point(2, 3)

p.toString()

p.hasOwnProperty('x')   // this 是实例对象自己的属性
p.hasOwnProperty('y')
p.hasOwnProperty('toString')    // toString 是原型对象的属性

p.__proto__.hasOwnProperty('toString')


```

### 原型链

当谈到继承时，JavaScript 只有一种结构：对象。每个实例对象（ object ）都有一个私有属性（称之为 __proto__ ）指向它的构造函数的原型对象（prototype ）。该原型对象也有一个自己的原型对象( __proto__ ) ，层层向上直到一个对象的原型对象为 null。根据定义，null 没有原型，并作为这个原型链中的最后一个环节。

几乎所有 JavaScript 中的对象都是位于原型链顶端的 Object 的实例。

原型的操作：
```
Object.getPrototypeOf()
Object.setPrototypeOf()
// 等价于 
obj.__proto__ 

```

#### 继承属性

当试图访问一个对象的属性时，它不仅仅在该对象上搜寻，还会搜寻该对象的原型，以及该对象的原型的原型，依次层层向上搜索，直到找到一个名字匹配的属性或到达原型链的末尾。




#### 继承方法

JavaScript 并没有其他基于类的语言所定义的“方法”。在 JavaScript 里，任何函数都可以添加到对象上作为对象的属性。



### 4 种对象的创建方法

#### 直接创建

```
var o = {name: 'Tom'}

function f() {

}

// o 与 f 都是对象
```

#### 使用构造器创建

new 后面的函数被称为构造器 constructor 

```
function Person() {
    this.name = 'name'
}

Person.prototype.sayHello = function() {
    console.log('say hello')    
}

let man = new Person()
```

#### class 关键字

```
class Person {
    constructor(name) {
        this.name = name;
    }
}

class Man extends Person {
    constructor(age) {
        super('')
        this.age = age
    }
}

let man = new Man()
```


### 其他

#### new 操作
```
var o = new Foo();

实际操作是
var o = new Object()    // 先创建对象实例
o.__proto__ = Foo.prototype // 设置实例的原型
Foo.call(o) // 调用 constructor
```

#### hasOwnProperty

检测是否自己是否定义了属性，不在原型链查找

```
// 不会在原型链递归查找，只在当前实例查找
obj.hasOwnProperty('prop') 
```

#### __propto__ 与 prototype

__propto__ 隐式原型

prototype 显示原型

1. 在 js 中，万物皆对象。Funtion 也是对象，方法的原型（Funtion.prototype）也是对象。对象具有属性 __proto__，指向构造该对象的构造函数的原型(构造函数的 prototype )。实例可以通过 __proto__ 调用构造函数原型链中的属性和方法。
2. Function 除了有 __ptoto__ 外，还有原型属性 prototype 。prototype 是一个指针，指向一个对象。在这个对象中包含了所有实例共享的属性和方法(这个对象叫做原型对象)。原型对象也有一个属性叫 constructor，这个属性指回原构造函数。

参考：https://www.zhihu.com/question/34183746

![img](/asserts/img/e83bca5f1d1e6bf359d1f75727968c11_hd.jpg)


#### js 中的类是如何存储的？有 metaclass 和 class 的概念吗？

#### 继承、覆盖、重载 是如何实现的？

属性和方法的继承，通过原型链来实现。属性和方法会递归向上查找，直到找到。

覆盖，就是重新定义一个方法即可。查找方法时，会优先查找到子类的方法。

没有 重载 的概念

#### es6 中的 class 是如何实现的？

class 是构造函数的语法糖

```
class Point {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  toString() {
    return '(' + this.x + ', ' + this.y + ')';
  }
}

typeof Point // function 是一个函数

等价于
function Point(x, y) {
  this.x = x;
  this.y = y;
}

Point.prototype.toString = function () {
  return '(' + this.x + ', ' + this.y + ')';
};

var p = new Point(1, 2);
```

#### js 中对象与类的关系是？

类中定义了所有对象共享的属性和方法，在 js 中通过函数的原型对象 (func.prototype) 来实现类的功能。

所以 一个类，实际是一个 Function 对象。类定一个属性和方法都在函数的原型对象上。Function 自身定义了类的构造函数。

#### 类的构造方法怎么定义？内存何时回收？

一个普通的函数，当通过 new 来创建一个实例。则该函数就是这个实例的构造方法。

实例的 __proto__ 指向构造方法的 prototype （构造方法的原型对象）。原型对象里包含共享的属性和方法。






