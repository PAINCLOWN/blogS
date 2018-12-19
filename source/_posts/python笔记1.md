---
title: python笔记1
date: 2018-12-19 16:50:26
tags: 
categories: python笔记
---

``` 
print("hello python!")

# 注释

"""
print("多行注释")
"""

"""
num_sun = int(input("请输入要打印的变量："))

print("打印变量：%d" %num_sun )

"""

#list列表 (array数组)可变

test_list = ["one","two","three","four"]
"""
print("打印当前列表长度：%d" %len(test_list))

del test_list[0]

print("打印下标为2的变量：%s" %test_list[2])
"""

name_for = "three"
list_index = 0

#num_name为临时变量
"""
for num_name in test_list:
    if name_for == num_name:
        print("找到匹配变量:%s" % num_name)
        break
    list_index + 1
else:
    print("遍历结束,未找到匹配变量")
"""

#tuple（元祖）不可变
info_tuple = ("one",12,2.5)

info_tuple2 = (12,)

tuple_name = 12
"""
for tmp_name in info_tuple:
    if tuple_name == tmp_name:
        print("找到匹配变量:%s" %tmp_name)
        break
    list_index + 1
else:
    print("遍历结束,未找到匹配变量")
"""
"""
print("打印当前元祖长度：%d" %len(info_tuple))
"""
#列表和元祖相互转换
list(test_list)
tuple(info_tuple)

#dict字典
person = {"name" : "老王",
          "age" : 50,
          "gender" : True,
          "height" : 1.65}
"""
person_key = "age"
person_value = person[person_key]

print("打印key:%s,对应的value:%s" %(person_key,person_value))
"""

#遍历string字符串

string = "abcd efghij"
"""
for h in string:
    print(h)
"""

#字符串切片
"""
print(string[3:7])
"""

#内置函数
#---打印元素数量
"""
print(len(info_tuple))
print(len(string))
"""
#----删除变量，删除后打印报错
"""
del(test_list)
print(len(test_list))
"""
#切片
"""
print("0123456789"[::3])
print(test_list[0:3])
"""
#  +
#----元祖列表合并
"""
new_tuple = tuple(test_list) + info_tuple
print(new_tuple)
"""
#运算符
#----元素是否存在
"""
name_if = tuple_name in info_tuple
print(name_if)
"""
#修改全局变量
"""
def demo1():
    #print(name_for)

    #修改全局变量前不能使用它，不然会报错
    # global 关键字，告诉 Python 解释器 name_for 是一个全局变量
    global name_for
    name_for = "zero"

    print(name_for)

demo1()
"""


```