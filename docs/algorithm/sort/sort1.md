
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
      for (int j = 0; j < n - i - 1; j++) {
        if (a[j] > a[j+1]) { // 交换
            int tmp = a[j];
            a[j] = a[j+1];
            a[j+1] = tmp;
            // 此次冒泡有数据交换(优化)
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

分为已排序区间和未排序区间，每次从未排序区间找一个元素，与已排序区间的元素作比较找到插入的位置。

``` java
/**
 * 1. 从未排序区间中找一个值A
 * 2. 值A与已排序区间中的数据从后往前比较，已排序区间的值可能会往后挪，直到A找到了合适的位置
 * 3. 把值A放到合适的位置（挪的值都比A大） 
 */
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
/**
 * 1. 已排序区间不动
 * 2. 遍历未排序区间，找到最小值的 minIndex
 * 3. 把最小值挪到已排序区间的末尾 
 */
  // a表示数组，n表示数组大小
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