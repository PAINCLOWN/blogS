---
title: python笔记11
date: 2018-12-19 17:00:26
tags: 
categories: python笔记
---

``` 
class Game(object):
    #class下创建的叫类属性
    #类属性记录类的相关特征
    topNum = 0

    #静态方法
    #静态方法不需要 实例属性 或调用 实例方法
    #也不需要访问 类属性 或调用 类方法
    @staticmethod
    def help():
        print("这是帮助信息")

    #类方法
    #类方法和实例方法的区别：
    #在类方法内部可直接访问类属性或者调用类方法
    #实例方法在类的外部实例化后访问
    @classmethod
        #类方法中的cls和实例方法中的self类似
    def showTopNum(cls):
        #使用cls.访问类属性
        print("最高分数为：%d" % cls.topNum)

    def __init__(self,playerName):
        self.playerName = playerName

    def startGame(self):
        print("%s 开始游戏" % self.playerName)
        #使用类名来修改分数
        Game.topNum = 99999

#通过类名调用类的静态方法
Game.help()
#通过类名调用类方法查看分数
Game.showTopNum()
#实例化一个对象并且初始化名字
game = Game("张三")
#调用实例方法，开始游戏
game.startGame()
#调用类方法查看分数
Game.showTopNum()
```