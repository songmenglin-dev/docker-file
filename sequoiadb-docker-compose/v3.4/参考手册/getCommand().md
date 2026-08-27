---
title: getCommand()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1557112303-edition_id-304
---

## 名称

getCommand - 获取上次执行的命令

## 语法

**cmd.getCommand()**

## 类别

Cmd

## 描述

获取上次执行的命令。

## 参数

无

## 返回值

返回上次执行的命令。

## 错误

如果出错则抛异常，并输出错误信息，可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息或通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。 关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

  * 新建一个 Command 对象
        
        > var cmd = new Cmd()

  * 执行命令（ Command 对象执行命令详细可参考[Cmd:run](/cn/sequoiadb-cat_id-1557112332-edition_id-304)）
        
        > cmd.run( "ls", "/opt/trunk/test" )
        test1
        test2
        test3

  * 获取上次执行的命令
        
        > cmd.getCommand()
        ls /opt/trunk/test
