---
title: python问卷星自动随机勾选
date: 2019-4-4
tags: 问卷星
categories: CODE
---

> 这是一个，自动勾选问卷星，用来敷衍问卷增加数量的python脚本，转载需注明文章来源。

## 描述
1.wjxConfig.py
	主要作用是根据读取url.txt中的信息来判断有无保存链接，以便不用每一次都输入链接。算是主程序吧。
2.wjx.py
	主要是核心处理部分。可以导入模块单独使用。
	
	*代码比较凌乱也写了很多备注
	
	2019-4-3
	发布代码
	2019-4-4
	修复判断url.txt的逻辑错误
	增加最后一次任务处理后无需再静默等待


### wjxConfig.py

``` javascript
'''
Author: PA1NCL0WN
'''
import wjx as wjxModle
import time

class config():

    instance = None

    initFlag = False

    def __new__(cls, *args, **kwargs):
        if cls.instance is None:
            cls.instance = super().__new__(cls)
        return cls.instance

    def __init__(self):
        if config.initFlag:
            return
        #读取保存的Url地址
        config.initFlag = True

    def run(self , url):
        print("当前处理：【%s】" % (wjxModle.wjxShowTitle(url).showTitle()))
        loopTimes = int(input("输入要刷的数量："))
        questionNum = int(input("输入问卷上问题的个数："))
        wjxModle.run(loopTimes, questionNum, url)


def judgeFile():
    try:
        file = open("url.txt")
    except:
        file = open("url.txt" , "w+")
    configStr = file.read()
    file.close()
    if configStr == "":
        inputUrl = input("请输入要处理的链接地址：")
        # 保存输入的链接到url.txt,保证报错异常之后链接依旧能储存
        file = open("url.txt", "w")
        file.write(inputUrl)
        file.close()
        file = open("url.txt")
        configUrl = file.read()
        print(configUrl)
        file.close()
        config2 = config()
        config2.run(inputUrl)
    else:
        chooseUrl()

def chooseUrl():
    #询问是否执行上次保存的链接
    while True:
        choose = input("已有保存链接，是否应用？Y/N")
        if choose in ["Y" , "y"]:
            file = open("url.txt")
            configUrl = file.read()
            print(configUrl)
            file.close()
            config1 = config()
            config1.run(configUrl)
            print("本次任务执行结束~")
            break
        elif choose in ["N", "n"]:
            inputUrl = input("请输入要处理的链接地址：")
            #保存输入的链接到url.txt,保证报错异常之后链接依旧能储存
            file = open("url.txt" , "w")
            file.write(inputUrl)
            file.close()
            file = open("url.txt")
            configUrl = file.read()
            print(configUrl)
            file.close()
            config2 = config()
            config2.run(inputUrl)
            break
        else:
            print("输入有误请重新输入。")

def saveConfig():
    while True:
        choose = input("是否保存本次处理链接？Y/N")
        if choose in ["Y" , "y"]:
            file = open("url.txt")
            congfigUrl = file.read()
            print(congfigUrl)
            print("保存成功")
            time.sleep(3)
            break
        elif choose in ["N", "n"]:
            file = open("url.txt" , "w")
            file.write("")
            break
        else:
            print("输入有误请重新输入。")



def mian():
    #1.判断是否有存储的链接
    # 2.根据用户选择来选择处理方法
    judgeFile()

    #3.执行结束询问是否保存链接
    saveConfig()

if __name__ == "__main__":
    mian()
```

### wjx.py

``` javascript
'''
Author: PA1NCL0WN
'''
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

    def __init__(self, time, questionNum , url):
        #判断是否初始化，如果初始化，则直接返回
        if wjx.init_flag:
            return
        #间隔时间
        self.time_second = time
        #初始化一个空列表
        self.xpathlist = []
        #初始化一个问题数量
        self.questionNum = questionNum
        #初始化一个要加载URL
        self.url = url
        #self.browser = webdriver.Chrome()
        self.titleAgain = ''
        self.titleAfter = ''
        self.chrome_op = Options()
        self.chrome_op.add_argument("--headless")
        wjx.init_flag = True

    def randomIndex(self , *option):
        #根据元祖长度生成随机index
        randomOptionIndex =  random.randint(0 , len(option) - 1)
        return option[randomOptionIndex]


    def grid(self):
        self.browser = webdriver.Chrome(chrome_options=self.chrome_op)
        self.browser.get(self.url)
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
            print("页面未跳转,选项不满足条件，重新勾选ing")
            return True

        else:
            print("页面已跳转，成功提交")
            return False



    def gridOver(self):
        self.browser.quit()

    def __str__(self):
        pass

class wjxShowTitle(wjx):
    instance = None
    init_flag = False
    def __new__(cls, *args, **kwargs):
        if cls.instance is None:
            cls.instance = super().__new__(cls)
        return cls.instance

    def __init__(self , urlStr):
        if wjxShowTitle.init_flag:
            return
        self.urlStr = urlStr
        self.chrome_op = Options()
        self.chrome_op.add_argument("--headless")
        self.browser = webdriver.Chrome(chrome_options=self.chrome_op)
        self.init_flag = True

    def showTitle(self):
        self.browser.get(self.urlStr)
        title =  self.browser.title
        self.gridOver()
        return title

def run(count , questionNum , url):
    for i in range(count):
        j = i + 1
        #控制总体勾选速度
        shua = wjx(0.1 , questionNum ,url)
        print("正在进行第%d次操作" % j)
        try:
            shua.grid()
        #捕获未知异常并且打印出来
        except Exception as result:
            print("出现异常：%s" % result)
            print("停止运行")
            break
        shua.gridOver()
        print("第%d次操作结束" % j)
        proportion = (j / count)*100
        print("处理进度：【%i/%i】·【%i%%】" % (j, count, proportion))
        while j != count:
            tempS = random.randint(15, 21)
            print("随机静默15~21s:【%ds】" % tempS)
            time.sleep(tempS)
            break


def main():
    loopTimes = int(input("输入要刷的数量："))
    questionNum = int(input("输入问卷上问题的个数："))
    url = input("输入要处理的链接：")
    print("当前处理：%s" % wjxShowTitle(url).showTitle())

    run(loopTimes , questionNum , url)
    

if __name__ == "__main__":
    main()


```