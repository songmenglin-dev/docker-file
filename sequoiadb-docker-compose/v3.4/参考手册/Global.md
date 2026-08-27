---
title: Global
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190765-edition_id-304
---

Global 类作用于全局范围，包含的函数如下：

名称 | 描述  
---|---  
[help()](/cn/sequoiadb-cat_id-1529976601-edition_id-304) | 显示帮助信息  
[print()](/cn/sequoiadb-cat_id-1529976602-edition_id-304) | 将输入内容输出到标准输出  
[sleep()](/cn/sequoiadb-cat_id-1529976603-edition_id-304) | 睡眠若干毫秒  
[forceGC()](/cn/sequoiadb-cat_id-1529976604-edition_id-304) | 强制 javascript 引擎回收已经释放的对象资源  
[showClass()](/cn/sequoiadb-cat_id-1586831518-edition_id-304) | 列举 sdb shell 内置的自定义类及内置的自定义类包含的所有方法  
[getErr()](/cn/sequoiadb-cat_id-1529976605-edition_id-304) | 获取错误码的描述信息  
[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) | 获取前一次操作的详细错误信息  
[getLastErrObj()](/cn/sequoiadb-cat_id-1482317447-edition_id-304) | 以 bson 对象的方式，返回前一次操作的详细错误信息  
[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) | 获取前一次操作返回的错误码  
[setLastErrMsg()](/cn/sequoiadb-cat_id-1529976615-edition_id-304) | 设置前一次操作的详细错误信息  
[setLastErrObj()](/cn/sequoiadb-cat_id-1529976616-edition_id-304) | 以 bson 对象的方式，设置前一次操作的详细错误信息  
[setLastError()](/cn/sequoiadb-cat_id-1529976617-edition_id-304) | 设置前一次操作返回的错误码  
[getExePath()](/cn/sequoiadb-cat_id-1529976609-edition_id-304) | 获取执行当前 js 脚本的程序的位置目录  
[getRootPath()](/cn/sequoiadb-cat_id-1529976610-edition_id-304) | 获取执行当前 js 脚本的程序的工作目录  
[getSelfPath()](/cn/sequoiadb-cat_id-1529976611-edition_id-304) | 获取当前执行的 js 脚本的位置目录  
[import()](/cn/sequoiadb-cat_id-1502694296-edition_id-304) | 导入执行指定的 js 文件  
[importOnce()](/cn/sequoiadb-cat_id-1502694324-edition_id-304) | 全局只导入执行一次指定的 js 文件  
[jsonFormat()](/cn/sequoiadb-cat_id-1509700737-edition_id-304) | 设置格式化打印 BSON  
[traceFmt()](/cn/sequoiadb-cat_id-1432190766-edition_id-304) | 将 trace 文件格式化为用户可读的内容并输出到指定文件
