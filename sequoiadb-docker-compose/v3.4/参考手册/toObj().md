---
title: toObj()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1568720820-edition_id-304
---

## 名称

toObj - 转换成对象

## 语法

**IniFile.toObj()**

## 类别

IniFile

## 描述

转换成对象。

## 参数

无

## 返回值

执行成功，返回对象.

执行失败，抛异常。

## 错误

如果出错则抛异常，并输出错误信息，可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息或通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

  * 打开一个 INI 文件。
        
        > var ini = new IniFile( "/opt/sequoiadb/file.ini", SDB_INIFILE_FLAGS_DEFAULT )

  * 转换成对象。
        
        > ini.toObj()
        {
          "info.name": "Alan",
          "info.age": 23
        }
