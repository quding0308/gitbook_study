

### 求最大公约数

    /// 递归实现 复杂度高
    int gcd(int a,int b) {
        if(a%b)
            return gcd(b,a%b);
        return b;
    }

    /*
    c语言的实现
    */
    void swapi(int *x, int *y) {
        int tmp = *x;
        *x = *y;
        *y = tmp;
    }

    int gcd(int m, int n) {
        int r;
        do {
            if (m < n)
            swapi(&m, &n);
            r = m % n;
            m = n;
            n = r;
        } while (r);
        return m;
    }
