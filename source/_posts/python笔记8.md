---
title: python笔记8
date: 2018-12-19 16:57:26
tags: 
categories: python笔记
---

``` 
def demo():
    num = int(input("输入一个整数被除数："))
    result = 100 / num
    return print(result)

# 异常捕获，并返回处理结果
try:
    demo()
# 处理ValueError错误
except ValueError:
    print("请按要求输入")
    demo()
    # 处理ZeroDivisionError错误
except ZeroDivisionError:
    print("不能除以0")
    demo()
except Exception as result:
    print("未知错误 %s" % result)
    demo()
else:
 # 没有异常才会执行的代码
    print("没有异常")
finally:
# 无论是否有异常，都会执行的代码
    print("无论是否有异常，都会执行的代码")

```