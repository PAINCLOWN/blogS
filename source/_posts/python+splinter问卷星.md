---
title: python+splinter问卷星
date: 2019-3-29
tags: 问卷星
categories: CODE
---

　　**突然接到了一个需求，就是要刷问卷星的问卷数量，所以写了一个简陋的代码。**

　　splinter没有研究出来怎么用无头浏览器

　　可能是splinter本来就没有设置参数的方法吧。

　　最后直接用selenium解决了。

　　因为splinter是基于selenium二次开发的，不如直接用selenium

　　反正我觉得splinter简单但是不是很灵活。
  
  

``` javascript
from splinter import Browser
import time
import random
class wjx:
    def __init__(self , time):
        self.time_second = time
        self.browser = Browser('chrome')
    def randomIndex(self , *option):
        #根据元祖长度生成随机index
        temp  = len(option) - 1
        randomOptionIndex =  random.randint(0 , temp)
        return option[randomOptionIndex]

    def grid(self):
        self.browser.visit('https://www.wjx.cn/jq/36596189.aspx')
        self.browser.find_by_text(self.randomIndex('男' , '女')).click()
        time.sleep(self.time_second)
        self.browser.find_by_text(self.randomIndex('18-25岁' , '18岁以下')).click()
        time.sleep(self.time_second)
        self.browser.find_by_text(self.randomIndex('二线城市' , '一线城市')).click()
        time.sleep(self.time_second)
        self.browser.find_by_text(self.randomIndex('经常' , '偶尔')).click()
        time.sleep(self.time_second)
        for i in range(5):
            self.browser.find_by_text(self.randomIndex('化妆品' , '零食' , '数码产品' , '服饰鞋帽')).click()
        time.sleep(self.time_second)
        self.browser.find_by_xpath(self.randomIndex('//*[@id="divquestion6"]/ul/li[2]/label' ,'//*[@id="divquestion6"]/ul/li[1]/label')).click()
        time.sleep(self.time_second)
        self.browser.find_by_xpath(self.randomIndex('//*[@id="divquestion7"]/ul/li[1]/label' , '//*[@id="divquestion7"]/ul/li[2]/label')).click()
        time.sleep(self.time_second)
        self.browser.find_by_xpath(self.randomIndex('//*[@id="divquestion8"]/ul/li[1]/label' , '//*[@id="divquestion8"]/ul/li[2]/label')).click()
        time.sleep(self.time_second)
        self.browser.find_by_xpath(self.randomIndex('//*[@id="divquestion9"]/ul/li[1]/label' , '//*[@id="divquestion9"]/ul/li[2]/label')).click()
        time.sleep(self.time_second)
        self.browser.find_by_xpath(self.randomIndex('//*[@id="divquestion10"]/ul/li[1]/label' , '//*[@id="divquestion10"]/ul/li[2]/label')).click()
        time.sleep(self.time_second)
        self. browser.find_by_text('否').click()
        time.sleep(self.time_second)
        self.browser.find_by_text('智能物流机器人').click()
        time.sleep(self.time_second)
        self.browser.find_by_text(self.randomIndex('众筹方案指导', '未使用但会尝试')).click()
        time.sleep(self.time_second)
        for i in range(5):
            self.browser.find_by_text(self.randomIndex('商品质量有保证' , '发票凭证完整正规' , '专业的商品包装技术' , '性价比高、优惠活动多' )).click()
        time.sleep(self.time_second)
        for i in range(5):
            self.browser.find_by_text(self.randomIndex('页面设计' , '商品质量' , '配送速度')).click()
        time.sleep(self.time_second)
        self.browser.find_by_value('提交').click()
    def gridOver(self):
        self.browser.quit()

    def __str__(self):
        pass

def run(count):
    for i in range(count):
        j = i + 1
        shua = wjx(0.2)
        print("正在进行第%d次操作" % j)
        shua.grid()
        time.sleep(5)
        shua.gridOver()
        tempS = random.randint(15, 21)
        print("随机静默15~21s:【%ds】" % tempS)
        time.sleep(tempS)
        print("第%d次操作结束" % j)

def wjxTitle():
    print("#" * 50)
    print("对京东网上平台消费者满意度的问卷调查")
    print("#" * 50)

wjxTitle()

num = int(input("输入要刷的数量："))

run(num)


```
虽然选项是随机的，但是一旦更换网页就需要重新写xpath，实在是死板。

 