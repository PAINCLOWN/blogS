---
title: 某某网页认领工具-oapi
date: 2019-10-16
tags: PYTHON
categories: CODE
---

> **
模拟点击弊端太多，不如直接拿到token，然后post，get。**

项目目录下的文件

src目录
>资源文件目录（图片、音频）

audioMess.py
>播放wav音频的，用于播放src目录下的提示音start.wav、success.wav

Core.py
>核心文件

``` javascript
# encoding:utf-8

'''
@author: PAINCLOWN_ZZJ


'''
#网络
import urllib
import requests
import websocket
import json

import time
import random
from tkinter import *
import tkinter.messagebox as mb
#pil的imageTk要在有创建tk对象的时候才可以用
from PIL import ImageTk
import threading
import verify
import heartBeatCheck
import info
import audioMess
from dingtalkchatbot.chatbot import DingtalkChatbot as dms


'''
#########################################################
初始化
#########################################################
'''
#UI
root = Tk()
version = 2.7
windowsTitle = "CCKing Beta %s" % version
root.title(windowsTitle)
#不可更改窗口大小
root.resizable(0,0)
#设置背景色
root.configure(background = '#191923')
#容器
montyLogin = Frame(root,background = '#191923')
montySwtich = LabelFrame(root,text = '通知',background = '#191923' ,foreground = '#E2C044',font="黑体")
montyMessage = LabelFrame(root,text='声音提醒',background = '#191923' ,foreground = '#E2C044',font="黑体")
#帐号
labelUser = Label(montyLogin , text = 'USER:' ,background = '#191923' ,foreground = '#E2C044',font="黑体")
textUser = Entry(montyLogin , width = 25,background = '#191923' ,foreground = '#FBFEF9',font="黑体",insertbackground = 'yellow')
#密码
labelPW = Label(montyLogin, text = 'PASSWORD:' ,background = '#191923' ,foreground = '#E2C044',font="黑体")
textPW = Entry(montyLogin , show = "✿" , width = 25 ,background = '#191923' ,foreground = '#FBFEF9',font="黑体" ,insertbackground = 'yellow')
#日志
textLog = Text(root , width = 40 , height = 10 ,background = '#191923' ,foreground = '#FBFEF9',font="黑体")

#状态动画
canvas = Canvas(root,background = '#191923', width = 64 , height = 64 ,highlightthickness = 0)
canvasFile = ''

#初始化空多线程变量
hbct = ''
pro = ''
timer = ''
wsHeart = ''

#websocket对象初始化
ws = ''

#oapi
loginUrl = 'oapi地址'
getListUrl = 'oapi地址'


#json需要用到的变量
headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
crmid = ''
token = ''
sendMess = ''
jobNumber = ''
name = ''
mobile = ''

#webhookToken
whToken1 = 'webhook'
whToken2 = 'webhook'


#心跳参数（速度，强制下线）
force = 0
speed = 0.5
adminSpeedText = ''

#登录静音
loginQuiet = StringVar()
loginQuiet.set('1')
#成功静音
succQuiet = StringVar()
succQuiet.set('1')
#通知人切换
modelSwitch = StringVar()
modelSwitch.set('1')

#user and pw
user = "000"
password = "000"

'''
#########################################################
全局
#########################################################
'''

#获取窗口坐标
winX = 0
winY = 0
def winFo(Event):
    global winX
    global winY
    winX = int(root.winfo_x())
    winY = int(root.winfo_y())
#振动一次的动画
def moveWin(x,y):
    for i in range(5):
        extet = 20
        rmNumFrag = int(random.randint(30,40)/extet)
        for i in range(extet):
            tempFrag = rmNumFrag * i
            tempRect = '+%s+%s' % (x+tempFrag,y+tempFrag)
            root.geometry(tempRect)
            root.update()
        for i in range(extet,-1,-1):
            tempFrag = rmNumFrag * i
            tempRect = '+%s+%s' % (x+tempFrag,y+tempFrag)
            root.geometry(tempRect)
            root.update()
#振动多线程
def jitter():
    jitterTh = threading.Thread(target=moveWin,args=(winX,winY))
    jitterTh.setDaemon(True)
    jitterTh.start()

#mbShowWarning警告窗口
def mbShowWarning(title , message):
    mb.showwarning(title , message)
#mbShowWarning多线程
def mbShowWarningThead(title , message):
    mbTh = threading.Thread(target = mbShowWarning,args = [title,message])
    mbTh.setDaemon(True)
    mbTh.start()

#状态动画
def canvasAni(fileName):
    global canvasFile
    canvasFile = PhotoImage(file = fileName)
    canvas.create_image(32,32,image = canvasFile)
    
#显示到最新的log,默认0是白色，1红色，2绿色，3黄色
def logCell(text , color=0):
    if color == 1:
        textLog.tag_config('tag1',background = '#191923' ,foreground = '#EF767A',font="黑体")
        textLog.insert('end' , text,('tag1'))
    elif color == 2:
        textLog.tag_config('tag2',background = '#191923' ,foreground = '#23F0C7',font="黑体")
        textLog.insert('end' , text,('tag2'))
    elif color == 3:
        textLog.tag_config('tag3',background = '#191923' ,foreground = '#FFE347',font="黑体")
        textLog.insert('end' , text,('tag3'))
    else:
        textLog.insert('end' , text)
    textLog.see('end')
    textLog.update()


#心跳传参
def HBCheck():
    global force
    global speed
    global whToken1
    global whToken2
    global hbct
    global pro
    hbVar = heartBeatCheck.getConfig()
    try:
        newVer = float(hbVar[0])
        speed = float(hbVar[1])
        force = int(hbVar[2])
        whToken1 = hbVar[3]
        whToken2 = hbVar[4]
        if newVer > version:
            jitter()
            canvasAni('src\\fail.png')
            tempStr = "请下载最新版本!\n当前版本:[ %s ]\n最新版本：[ %s ]" % (version , newVer)
            mbShowWarningThead("有新版本更新" , tempStr)
            logCell("[请更新到最新版本，老版本会影响使用]\n" ,1)

        elif version > newVer:
            logCell("厉害了，你是咋赶在作者之前写出新版本的？\n" , 2)
            logCell("当前版本：[ %s ] \n" % version ,2)
            logCell("最新版本：[ %s ]\n" % newVer ,2)
        if force == 1:
            jitter()
            canvasAni('src\\fail.png')
            try: 
                ws.close()
            except Exception as e:
                print(e)
            logCell('=！=被主机熔断STOP=！=\n' , 1)
    except Exception as e:
        print(e)
        logCell("!?!配置未获取5分钟自动重试!?!\n" , 1)       
    hbct = threading.Timer(300 , HBCheck)
    hbct.setDaemon(True)
    hbct.start()

#线程数查询
def ThreadNum():
    thNum = threading.active_count()
    thStr = "ThNum : %s" % thNum
    return thStr


startAniStop = 1
def startAni():
    while startAniStop:
        for i in range(12):
            if startAniStop:
                tempStr = 'src\\fxxk\\%s.png' % i
                canvasAni(tempStr)
                time.sleep(0.07)
            else:
                break

def switchStartAndStop(switch):
    global startAniStop
    if switch:
        startAniStop = 1
        temStr = '努力中'
        buttonRun.configure(text=temStr)
        startAniTh = threading.Thread(target = startAni)
        startAniTh.setDaemon(True)
        startAniTh.start()
    else:
        startAniStop = 0
        canvasAni('src\\stop.png')
        temStr = '已暂停'
        buttonRun.configure(text=temStr)
        
def getAD():
    #捕获image没有加载出来的异常
    img = info.getImg()
    print('img:%s' % img)
    if  img == "":
        print('没有获取到AD')
        getADTh = threading.Timer(60,getAD)
        getADTh.setDaemon(True)
        getADTh.start()
    else:
        w,h = img.size
        print(w , h)
        imgResize = info.resize(w,h,350,200,img)
        tkImage = ImageTk.PhotoImage(imgResize)
        labelImg = Label(root , image = tkImage)
        labelImg.grid(row = 12)
        root.update()

'''
#########################################################
功能部分
#########################################################
'''

#管理员提交speed参数
def changeSpeed():
    global speed
    #停止更新参数
    if hbct.is_alive():
            logCell('config多线程停止\n')
    try:
        hbct.cancel()
    except Exception as e:
        print(e)
    speed = adminSpeedText.get()
    logCell('speed:%s\n' % speed)

#查看未处理工单
def getList():
    global force
    tokenStr = '%s' % (token)
    temheaders = {'token':tokenStr,'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
    noListJson = {"jobsheetStatus":[2,3,6],"tabset":0,"tabType":1,"findType":3,"crmId":crmid,"organizationId":5,"size":10,"page":1}
    noWaitListJson = {"jobsheetStatus":[6,7],"tabset":1,"tabType":2,"findType":3,"crmId":crmid,"organizationId":"0005","size":10,"page":0}
    getNoListPost = requests.post(getListUrl , json=noListJson , headers = temheaders)
    getNoWaitListPost = requests.post(getListUrl , json=noWaitListJson , headers = temheaders)
    getNoListDict = json.loads(getNoListPost.text)
    getNoWaitListDict = json.loads(getNoWaitListPost.text)
    if getNoListDict['data']['total'] >0:
        logCell('未处理工单数量：%s\n' % getNoListDict['data']['total'],3)
    if  getNoWaitListDict['data']['total'] > 0:
        logCell('待跟进工单数量：%s\n' % getNoWaitListDict['data']['total'],3)
    if getNoListDict['data']['total'] >= 3:
        logCell('未处理工单超过3个，无法继续领取工单！\n',1)
        logCell('提示：处理完后点击[检测数量]重新检测未处理工单\n',1)
        #开始按钮部署
        buttonRun.configure(text = '检测数量' , command = getList ,background = '#ae0c00' ,highlightthickness = 0)
        buttonRun.grid(row = 7,padx=5,pady=5)
        force = 1
        canvasAni('src\\fail.png')
    else:
        if force == 1:
            logCell('工单数量恢复正常，可以正常使用\n',3)
        buttonRun.configure(text = 'Start' , command = run ,background = '#226CE0' ,highlightthickness = 0 )
        buttonRun.grid(row = 7,padx=5,pady=5)
        force = 0
    if getNoListDict['data']['total'] > 0:
        logCell('请及时处理未处理工单！\n',1)
    if getNoWaitListDict['data']['total'] > 0:
        logCell('请及时处理待跟进工单！\n',1)

#自动登录
def autoLogin():
    pwData = {'userName': user, 'password': password}
    pwPost = requests.post(loginUrl , json=pwData , headers=headers)
    #json转字典
    PWresult = json.loads(pwPost.text)
    global token
    global crmid
    global name
    global mobile
    global adminSpeedText
    try:
        token = PWresult['data']['userInfo']['token']
        crmid = PWresult['data']['userInfo']['id']
        name = PWresult['data']['userInfo']['name']
        mobile = PWresult['data']['userInfo']['mobile']
    except Exception as e:
        print(e)
        print('POST返回参数不完整，没有登录')

    if PWresult["code"] == 10000:
        canvasAni('src\\start.png')
        logCell('==登录成功==\n')
        tempName = '【你好，%s】\n' % name 
        logCell(tempName)
        #移除登录框
        montyLogin.grid_forget()
        #移除登录按钮
        buttonSend.grid_forget()
    
        root.bind('<Return>' , '')
        getList()
        #mark
        userList = ["管理员的帐号"]
        if user in userList:
            logCell('你好！尊敬的管理员,现在你可以为所欲为了。\n' , 3)
            adminSpeedLabel = Label(root , text = 'SPEED:' ,background = '#191923' ,foreground = '#E2C044',font="黑体")
            adminSpeedText = Entry(root ,width = 12,background = '#191923' ,foreground = '#FBFEF9',font="黑体",insertbackground = 'yellow')
            adminSpeedText.insert('end' , speed)
            adminSpeedButton = Button(root,text='OK',command =changeSpeed,background = '#226CE0' ,foreground = '#FBFEF9',font="黑体" ,highlightthickness = 0)
            adminSpeedLabel.grid(row = 11,sticky=W,padx=5,pady=5)
            adminSpeedText.grid(row = 11,padx=5,pady=5)
            adminSpeedButton.grid(row = 11,sticky=E,padx=5,pady=5)
        root.update()
    else:
        jitter()
        canvasAni('src\\fail.png')
        logCell(PWresult['msg']+"\n" , 1)


#websocket相关状态对应方法
def on_open(ws):
    global wsHeart
    ws.send(sendMess)
    wsHeart = threading.Timer(45,on_open,[ws])
    wsHeart.setDaemon(True)
    wsHeart.start()

#正常抢：return 0没查询到（循环get），1工单被抢走（执行补抢参数1），2成功抢到
def okGetR(jobNumber, buqiang = 0):
    okApiGet = 'oapi地址=%s' % (jobNumber)
    
    tokenStr = '%s' % (token)
    temheaders = {'Sec-Fetch-Mode':'cors','token':tokenStr,'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
    okGet = requests.get(okApiGet , headers=temheaders)
    print('okGet:%s' % okGet.text)
    okGetDict = json.loads(okGet.text)
    #{"code":190003,"msg":"工单已被抢走"}
    if okGetDict["msg"] == "工单已被抢走":
        jobGetDict = ''
        while True:
            jobApiGet ='oapi地址%s' % (jobNumber)
            jobGet = requests.get(jobApiGet , headers=temheaders)
            jobGetDict = json.loads(jobGet.text)
            print("工单动态1：%s" % jobGetDict["data"])
            #判断不为空
            jobGetDataDict  = json.dumps(jobGetDict["data"])
            if jobGetDataDict:
                print("工单动态2：%s" % jobGetDataDict)
                break
            time.sleep(0.1)
        #补抢无返回值直接显示
        if buqiang == 1:
            canvasAni('src\\erro.png')
            logCell('   =!= 补抢失败0x1 =!=\n')
            if okGetDict["data"] == "2":
                logCell('   =!= 补抢失败0x2 =!=\n')
        else:
            return 1
    #{"code":190003,"msg":"工单信息不存在"}
    elif okGetDict["msg"] == "工单信息不存在":
        return 0
    #{"code":10000,"msg":"操作成功","data":2}
    elif okGetDict["data"] == 2:
        jobApiGet ='oapi地址%s' % (jobNumber)
        jobGet = requests.get(jobApiGet , headers=temheaders)
        print('jobGet:%s' % jobGet.text)
        #补抢无返回值直接显示
        if buqiang == 1:
            logCell('   =!= 补抢失败0x1 =!=\n')
            if okGetDict["data"] == "2":
                logCell('   =!= 补抢失败0x2 =!=\n')
        return 1
    #{"code":10000,"msg":"操作成功","data":1}
    elif okGetDict["data"] == 1:
        return 2

def on_message(ws,message):
    global jobNumber
    print('message:%s' % message)
    messDict = json.loads(message)
    messInfo = '%s\n' % messDict["content"]
    messType = messDict["type"]
    jobNumber = messDict["jobNumber"]
    logCell(messInfo)
    if messType == 1:
        while True:
            try:
                tempGet = okGetR(jobNumber)
            except Exception as e:
                print(e)
            if tempGet == 0:
                time.sleep(float(speed))
                continue
            elif tempGet == 1:
                logCell('   =!= 工单已被抢走嗷 =!=\n')
                logCell('   !!!准备开始补抢单!!!\n',2)
                time.sleep(20)
                bu = threading.Thread(target = okGetR ,args =[jobNumber , 1])
                bu.setDaemon(True)
                bu.start()
                break
            #成功
            elif tempGet == 2:
                break
            else:
                print('tempGet:%s' % tempGet)
                logCell('   =?= 未知错误，请反馈 =?=\n')
                ws.close()
                break
    elif messType == 2:
        jitter()
        canvasAni('src\\ok.png')
        logCell('领取成功，返回系统查看，Start可继续\n' , 3)
        #弹出提示
        if succQuiet.get() == "1":
            audioMess.playAudio('src\\success')
        if modelSwitch.get() == "1":
            webhook = 'https://oapi.dingtalk.com/robot/send?access_token=%s' % (whToken1)
        else:
            webhook = 'https://oapi.dingtalk.com/robot/send?access_token=%s' % (whToken2)
        bling = dms(webhook)
        tempMobile = [mobile]
        tempMess = '工单(%s)被这个家伙抢到了,大家请针对他' % (jobNumber)
        bling.send_text(msg = tempMess , at_mobiles=tempMobile)
        ws.close()
        mbShowWarning("嗯哼嗷" , "我好了，你抓紧时间赶快处理！")
        
        

def on_error(ws,error):
    print("ws异常：%s" % error)


def on_close(ws):
    jitter()
    switchStartAndStop(False)
    if wsHeart.is_alive():
        wsHeart.cancel()
    logCell('连接断开，请重新开始\n')
    print('ws连接断开')


#处理
def processOrder():
    global sendMess
    global ws
    sendMess = '不告诉你发送的啥%s' % crmid
    wsUrl = 'wss api地址' % crmid
    websocket.enableTrace(True)
    ws = websocket.WebSocketApp(wsUrl , on_message=on_message,on_error=on_error , on_close=on_close)
    ws.on_open = on_open
    jitter()
    logCell('开始等待工单···\n')
    ws.run_forever()
    
    '''
    gongListUrl = 'oapi地址'
    tokenStr = '%s' % (token)
    temheaders = {'token':tokenStr,'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
    gongReq = requests.get(gongListUrl , headers=temheaders)
    gongDict = json.loads(gongReq.text)
    print(gongDict)
    '''
#登录按钮

#回车登录（一定要传Event）
def entSendUserAndPw(Event):
    global user
    user = textUser.get()
    global password
    password = textPW.get()
    autoLogin()

#点击登录
def buttonSendUserAndPw():
    global user
    user = textUser.get()
    global password
    password = textPW.get()
    autoLogin()
#发送按钮
buttonSend = Button(root , text = "login" ,height = 1,width = 12, command  = buttonSendUserAndPw ,background = '#226CE0' ,foreground = '#FBFEF9',font="黑体" ,highlightthickness = 0)


#多线程
def run():
    global pro
    global hbct
    getList()
    if force == 0:
        if pro == '':
            pro = threading.Timer( 0,processOrder)
        if loginQuiet.get() == "1":
            audioMess.playAudio('src\\start')
        if not pro.is_alive():
            hbct = threading.Timer(0,HBCheck)
            hbct.setDaemon(True)
            hbct.start()
            pro = threading.Timer( 0,processOrder)
            pro.setDaemon(True)
            pro.start()
            switchStartAndStop(True)
            print('当前线程数：%s' % ThreadNum())
        else:
            wsHeart.cancel()
            ws.close()
            switchStartAndStop(False)
            logCell( '  ==xx已停止xx==\n')
            print('当前线程数：%s' % ThreadNum())
    else:
        logCell('=！=被主机熔断STOP=！=\n' , 1)

def mainQuit():
    try:
        wsHeart.cancel()
    except Exception as e:
        print(e)
    try:
        ws.close()
    except Exception as e:
        print(e)
    try:
        pro.cancel()
    except Exception as e:
        print(e)
    try:
        hbct.cancel()
    except Exception as e:
        print(e)
    root.quit()

#初始化一个运行按钮
buttonRun = Button(root , text = 'Start' ,height = 1,width = 12, command = run ,background = '#226CE0' ,foreground = '#FBFEF9',font="黑体",highlightthickness = 0)
#退出按钮
buttonQuit = Button(root , text = "exit" ,height = 1,width = 12, command  = mainQuit ,background = '#393E41' ,foreground = '#FBFEF9',font="黑体",highlightthickness = 0)

    
def main():
    global loginQuiet
    global succQuiet
    global hbct
    checkTime = verify.checkTime()
    if checkTime[0]:
        labelInfo = Label(root , text = info.getInfo() ,background = '#191923' ,foreground = '#FBFEF9',font="黑体")
        labelInfo.grid(row =0)
        labelVerify = Label(root , text = checkTime[1] , width = 30 , height = 1 ,background = '#191923' ,foreground = 'Tomato',font="黑体")
        labelVerify.grid(row = 1)
        labelUser.grid(row = 0 ,column=1, sticky=W,padx=5,pady=5)
        textUser.grid(row = 0 , column=2,padx=5,pady=5)
        labelPW.grid(row = 1 , column=1,padx=5,pady=5)
        textPW.grid(row = 1 , column=2,padx=5,pady=5)
        montyLogin.grid(row = 2,padx=5,pady=5)
        model1Radio = Radiobutton(montySwtich ,text = "强东通知" ,variable = modelSwitch ,value = '1', background = '#191923' ,foreground = 'Tomato',font="黑体" ,highlightthickness = 0) 
        model2Radio = Radiobutton(montySwtich ,text = "嘉宾通知" ,variable = modelSwitch ,value = '2', background = '#191923' ,foreground = 'Tomato',font="黑体" ,highlightthickness = 0) 
        model1Radio.grid(column=1,row=0,padx=20,pady=5)
        model2Radio.grid(column=2,row=0,padx=20,pady=5)
        canvasAni('src\\start.png')
        canvas.grid(row = 3,padx=5,pady=5)
        montySwtich.grid(row = 4 ,padx=5,pady=5)
        quietSent = Checkbutton(montyMessage , text = "开始提醒" ,variable = loginQuiet ,onvalue = '1',offvalue = '0', background = '#191923' ,foreground = 'Tomato',font="黑体",highlightthickness = 0)
        quietSuss = Checkbutton(montyMessage , text = "成功提醒" ,variable = succQuiet ,onvalue = '1',offvalue = '0', background = '#191923' ,foreground = 'Tomato',font="黑体",highlightthickness = 0)
        quietSent.grid(row = 0,column=1,padx=20,pady=5)
        quietSuss.grid(row = 0,column=2,padx=20,pady=5)
        montyMessage.grid(row = 6,padx=5,pady=5)
        buttonSend.grid(row = 7,padx=5,pady=5)
        buttonQuit.grid(row = 8,padx=5,pady=5)
        textLog.grid(row = 9,padx=5,pady=5)
        root.bind('<Return>' , entSendUserAndPw)
        #图标
        root.iconbitmap('favicon.ico')
        getADTh = threading.Timer(0 ,getAD)
        getADTh.setDaemon(True)
        getADTh.start()
        #绑定窗口位置方法
        root.update()
        root.bind('<Configure>', winFo)
        root.mainloop()
    else:
        labelVerify = Label(root , text = checkTime[1] , width = 30 , height = 1 ,background = '#191923' ,foreground = '#DC493A' ,font="黑体")
        labelVerify.grid(row = 0,padx=5,pady=5)
        canvasAni('src\\fail.png')
        canvas.grid(row = 3,padx=5,pady=5)
        #图标
        root.iconbitmap('favicon.ico')
        root.mainloop()

if __name__ == "__main__":
    main()


```

favicon.ico
>icon图标文件

heartBeatCheck.py
>心跳检测，5分钟获取一下网站给的参数是否要强制禁止运行，还有点击速度

``` javascript
# encoding:utf-8
'''
@author: PAINCLOWN_ZZJ
1.检测云端配置
2.验证云端配置
3.传出配置到Core
4.对比新旧版本号
'''
from urllib.request import Request, urlopen
import json

def getConfig():
    try:
        headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0'}
        req = Request('oapi', headers = headers)
        hbConfig = (urlopen(req).read()).decode('utf-8')
        print(hbConfig)
        ConfigDict = json.loads(hbConfig)
        newVer = ConfigDict["newVer"]
        speed = ConfigDict["time"]
        force = ConfigDict["force"]
        webhook1 = ConfigDict["tk1"]
        webhook2 = ConfigDict["tk2"]


        return newVer , speed , force , webhook1 , webhook2
    except:
        return '','','','',''


def main():
    print(getConfig())
    

if __name__ == "__main__":
    main()
```

info.py
>从网页获取一个公告和img广告条

``` javascript
#encode=utf-8
'''
@author: PAINCLOWN_ZZJ
'''
import time
import http as client
from urllib.request import Request, urlopen
import re
#pillow处理图片
from PIL import Image
#io用来吧图片保存到内存
import io


def getInfo():
    try:
        headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0'}
        req = Request('oapi', headers = headers)
        infoMessage = (urlopen(req).read()).decode('utf-8')
        return infoMessage
    except:
        null = ''
        return null

def getImg():
    try:
        headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0'}
        req = Request('oapi', headers = headers)
        url = (urlopen(req).read()).decode('utf-8')
        req = Request(url, headers = headers)
        imgBytes = urlopen(req).read()
        data = io.BytesIO(imgBytes)
        pilImg = Image.open(data)
        return pilImg
    except:
        null = ''
        return null

#图片缩放
def resize(w, h, w_box, h_box, pil_image):  
    ''''' 
    对一个pil_image对象进行缩放，让它在一个矩形框内，还能保持比例 
    '''  
    f1 = 1.0*w_box/w # 1.0 forces float division in Python2  
    f2 = 1.0*h_box/h  
    factor = min([f1, f2])  
    #print(f1, f2, factor) # test  
    # use best down-sizing filter  
    width = int(w*factor)  
    height = int(h*factor)  
    return pil_image.resize((width, height), Image.ANTIALIAS) 


def main():
    print(getImg())

if __name__ == "__main__":
    main()
```

verify.py
>授权时间验证，用于控制工具可用的时间

``` javascript
# encoding:utf-8
'''
@author: PAINCLOWN_ZZJ
1.获取本地时间
2.获取网络时间
3.对比本地网络时间
4.对比网络授权时间
5.授权认证是否通过
'''

import time
import http as client
from urllib.request import Request, urlopen
import re

verifyY = ''
verifyM = ''
verifyD = ''

def getAuth():
    headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0'}
    req = Request('oapi', headers = headers)
    try:
        authTime = (urlopen(req).read()).decode('utf-8')
    except:
        return False
    print(type(authTime))
    print(authTime)
    global verifyY
    verifyY = re.search('\d{4}' , authTime).group()
    tempM = re.search('-\d{1,2}-' , authTime).group()
    global verifyM
    verifyM = re.search('\d{1,2}' , tempM).group()
    tempD = re.search('-\d{1,2}$' , authTime).group()
    global verifyD
    verifyD = re.search('\d{1,2}' , tempD).group()
    return True
def getLocalTime():
    localTime = time.localtime()
    return localTime

def getNetTime(host):
    try:
        conn=client.client.HTTPConnection(host)
        conn.request("GET", "/")
        r=conn.getresponse()
        ts=  r.getheader('date')
        #获取http头date部分
        #将GMT时间转换成北京时间
        local_time= time.mktime(time.strptime(ts[5:], "%d %b %Y %H:%M:%S GMT")) + (8 * 60 * 60)
        ltime = time.gmtime(local_time)
        return ltime
    except:
        return False

def checkTime():
    temp = getAuth()
    if temp:
        localTimeList = getLocalTime()
        netTimeList = getNetTime('baidu.com')
        if netTimeList:
            if (localTimeList[0] == netTimeList[0]) and (localTimeList[1] == netTimeList[1]) and (localTimeList[2] == netTimeList[2]):
                #print("时间认证成功")
                if int(verifyY) > netTimeList[0]:
                    #print("授权认证成功")
                    return(True , "授权认证成功 0x1")
                elif int(verifyY) == netTimeList[0]:
                    if int(verifyM) > netTimeList[1]:
                        return(True , "授权认证成功 0x2")
                    elif int(verifyM) == netTimeList[1]:
                        if int(verifyD) >= netTimeList[2]:
                            return(True , "授权认证成功 0x3")
                        else:
                            return(False , "授权过期，请获取授权 0x6")
                    else:
                        return(False , "授权过期，请获取授权 0x5")
                else:
                    #print("授权过期，请重新获取授权")
                    return(False , "授权过期，请获取授权 0x4")
            else:
                #print("时间认证失败，程序结束")
                return(False , "时间认证失败，请检查网络 0x3")
        else:
            return(False , "连接失败，请检查网络 0x2")
    else:
        return(False , "连接失败，请检查网络 0x1")
def main():
    checkTime()

if __name__ == "__main__":
    main()
```

> 没有可更新的地方了，也没啥bug了。功能比较完善。唯一让我难受的是，自带的tk不如pyqt5功能多，但qt5没习惯真的超级难用，还是花时间研究一下qt5的用法吧。
