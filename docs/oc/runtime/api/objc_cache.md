## objc_cache

### 使用

用于缓存 class 的消息

```
struct objc_class {
    struct objc_cache cache;
}

```

### 实现

```
struct objc_cache {
    unsigned int mask; //指定分配缓存bucket的总数。total = mask + 1 runtime使用这个字段确定线性查找数组的索引位置
    unsigned int occupied; //实际占用缓存bucket总数
    Method buckets[1]; //指向Method数据结构指针的数组，这个数组的总数不能超过mask+1，但是指针是可能为空的，这就表示缓存bucket没有被占用，数组会随着时间增长。
};

```
