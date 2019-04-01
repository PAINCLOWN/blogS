---
title: python+selenium问卷星
date: 2019-4-1
tags: 问卷星
categories: CODE
---

用单例写了一下，哈哈哈哈哈

其他没变动，等出现新的状况再更新。

``` javascript
from selenium.webdriver.chrome.options import Options
from selenium import webdriver
import time
import random
import re

class wjx():
    #用来判断是否创建内存空间
    instance = None
    # 用来判断是否初始化
    init_flag = False
    def __new__(cls, *args, **kwargs):
        #如果创建内存，则不用再创建直接返回
        if cls.instance is None:
            cls.instance = super().__new__(cls)
        return cls.instance
    def __init__(self, time, questionNum):
        #判断是否初始化，如果初始化，则直接返回
        if wjx.init_flag:
            return
        #间隔时间
        self.time_second = time
        #初始化一个空列表
        self.xpathlist = []
        #初始化一个问题数量
        self.questionNum = questionNum
        self.chrome_op = Options()
        self.chrome_op.add_argument("--headless")
        self.browser = webdriver.Chrome(chrome_options=self.chrome_op)
        #self.browser = webdriver.Chrome()
        self.titleAgain = ''
        self.titleAfter = ''
        wjx.init_flag = True
    def randomIndex(self , *option):
        #根据元祖长度生成随机index
        randomOptionIndex =  random.randint(0 , len(option) - 1)
        return option[randomOptionIndex]

    def grid(self):
        self.browser.get('https://www.wjx.cn/jq/36596189.aspx')
        #获取填写时的title方便后面做跳转判断
        self.titleAgain = self.browser.title
        print("开始处理问题")
        for i in range(self.questionNum):
            #这里的10是问题下面选项的数量，一般不会有很多吧，所以就写死
            for j in range(10):
                tmpNum =  i + 1
                j += 1
                xpath = '//*[@id="divquestion%d"]/ul/li[%d]/label' % (tmpNum , j)
                #添加进初始化好的列表
                self.xpathlist.append(xpath)
            # 这里的10是问题下面选项的数量，开始处理无用的元素，抛出异常的就是没有搜索到，所以利用这个处理一下列表
            for a in range(10):
                try:
                    #搜索xpath
                    self.browser.find_element_by_xpath(self.xpathlist[-1])
                except :
                    #遍历移除xpathlist中没用的元素
                    self.xpathlist.pop()
                    continue
            tmpTuple = tuple(self.xpathlist)
            for b in range(len(tmpTuple)):
                self.browser.find_element_by_xpath(self.randomIndex(*tmpTuple)).click()
            #用完之后把列表置空
            self.xpathlist = []
            time.sleep(self.time_second)
        self.browser.find_element_by_xpath('//*[@id="submit_button"]').click()
        time.sleep(2)
        #处理alert，不然会异常，如果不捕获异常一样无法运行
        try:
            self.browser.switch_to_alert().accept()
        except:
            pass

        self.titleAfter = self.browser.title
        #判断页面是否跳转，未跳转则递归重新处理选项
        if self.jumpPage(self.titleAgain , self.titleAfter):
            self.grid()
            return
        else:
            #处理URL中显示的问卷总数
            print(self.browser.current_url)
            #获取url
            urlStr = self.browser.current_url
            #正则匹配需要的内容,group(0)是匹配到的第一组
            urlStrAfter = re.search('jidx=[0-9]+&', urlStr).group(0)
            #字符串切片
            print("问卷总数:%s" % urlStrAfter[5 : -1])


    #判断页面是否跳转如果title相等就是没有跳转返回1，不相等就是跳转返回0
    def jumpPage(self , titleAgain , titleAfter):
        if titleAgain == titleAfter:
            print("页面未跳转，有填写选项，重新勾选ing")
            return True

        else:
            print("页面已跳转，成功提交")
            return False



    def gridOver(self):
        self.browser.quit()

    def __str__(self):
        pass

def run(count , questionNum):
    for i in range(count):
        j = i + 1
        #控制总体勾选速度
        shua = wjx(0.1 , questionNum)
        print("正在进行第%d次操作" % j)
        shua.grid()
        shua.gridOver()
        print("第%d次操作结束" % j)
        proportion = (j / count)*100
        print("处理进度：【%i/%i】·【%i%%】" % (j, count, proportion))
        tempS = random.randint(15, 21)
        print("随机静默15~21s:【%ds】" % tempS)
        time.sleep(tempS)

def wjxTitle():
    print("#" * 50)
    print("对京东网上平台消费者满意度的问卷调查")
    print("#" * 50)

wjxTitle()

loopTimes = int(input("输入要刷的数量："))
questionNum = int(input("输入问卷上问题的个数："))
run(loopTimes , questionNum)


```