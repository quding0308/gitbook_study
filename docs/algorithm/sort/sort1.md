
### 比较

![图片](http://pc5ouzvhg.bkt.clouddn.com/348604caaf0a1b1d7fee0512822f0e50.jpg)

从代码实现上来看，冒泡排序的数据交换要比插入排序的数据移动要复杂，冒泡排序需要 3 个赋值操作，而插入排序只需要 1 个。


### 冒泡排序

1. 是原地排序
2. 是稳定排序
3. 时间复杂度：O(n^2)

``` java 
// 冒泡排序，a是数组，n表示数组大小
public static void bubbleSort(int[] a, int n) {
if (n <= 1) return;

for (int i = 0; i < n; ++i) {
    // 提前退出标志位
    boolean flag = false;
    for (int j = 0; j < n - i - 1; ++j) {
    if (a[j] > a[j+1]) { // 交换
        int tmp = a[j];
        a[j] = a[j+1];
        a[j+1] = tmp;
        // 此次冒泡有数据交换
        flag = true;
    }
    }
    if (!flag) break;  // 没有数据交换，提前退出
}
}
```
### 插入排序

1. 是原地排序
2. 是稳定排序
3. 时间复杂度：O(n^2)

第n个元素 保证前n个元素有序，然后取第n个元素与前n-1个元素比较，找到合适的位置插入，保证前n个元素有序。

``` java
// 插入排序，a 表示数组，n 表示数组大小
public void insertionSort(int[] a, int n) {
  if (n <= 1) return;

  for (int i = 1; i < n; i++) {
    int value = a[i];
    int j = i - 1;
    // 查找插入的位置
    for (; j >= 0; j--) {
      if (a[j] > value) {
        a[j+1] = a[j];  // 数据移动
      } else {
        break;
      }
    }
    a[j+1] = value; // 插入数据
  }
}
```

### 选择排序

1. 是原地排序
2. 不是稳定排序
3. 时间复杂度：O(n^2)

选择排序算法的实现思路有点类似插入排序，也分已排序区间和未排序区间。但是选择排序每次会从未排序区间中找到最小的元素，将其放到已排序区间的末尾。

``` java
  // 选择排序，a表示数组，n表示数组大小
  public void selectionSort(int[] a, int n) {
    if (n <= 1) return;
    for (int i = 0; i < n - 1; i++) {
      // 查找最小值
      int minIndex = i;
      for (int j = i + 1; j < n; j++) {
        if (a[j] < a[minIndex]) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        // 交换
        int tmp = a[i];
        a[i] = a[minIndex];
        a[minIndex] = tmp;
      }
    }
  }
```

### 希尔排序

[https://zh.wikipedia.org/wiki/%E5%B8%8C%E5%B0%94%E6%8E%92%E5%BA%8F](https://zh.wikipedia.org/wiki/%E5%B8%8C%E5%B0%94%E6%8E%92%E5%BA%8F)