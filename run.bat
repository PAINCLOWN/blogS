@echo off
cd %~d0
cd %cd%

echo 清空hexo缓存
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo;
call  hexo_clean.bat
echo;
echo 清空完成
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


echo;
echo 生成静态页面
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo;
call hexo_g.bat
echo;
echo 生成完成
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


echo;
echo 同步到远程blog仓库
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo;
call hexo_d.bat
echo;
echo 同步完成
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


echo;
echo 同步hexo到blogS仓库
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo;
call gitSync.bat
echo;
echo 同步完成
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

echo;
=======
echo;

pause