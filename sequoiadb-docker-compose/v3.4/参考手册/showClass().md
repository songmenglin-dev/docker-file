---
title: showClass()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1586831518-edition_id-304
---

## 名称

showClass - 列举 sdb shell 内置的自定义类及内置的自定义类包含的所有方法

## 语法

**_showClass([className])_**

## 类别

Global

## 描述

该方法用于列举所有 sdb shell 支持的内置自定义类或者列举指定的内置自定义类包含的所有方法。

## 参数

  * `className` ( _String_ ， _选填_ )

需要列举的类名

## 返回值

className 为空时，返回所有 sdb shell 支持的内置自定义类；className 不为空时，返回指定的内置自定义类包含的所有方法。

## 版本

v2.8及以上版本

## 示例

  1. 列举所有 sdb shell 支持的内置自定义类
         
         > showClass()
         All classes:
            BSONArray
            BSONObj
            BinData
            CLCount
            Cmd
            ...
         Global functions:
            catPath()
            forceGC()
            getExePath()
            getLastErrMsg()
            ...
         Takes 0.000518s.

  2. 列举类 SdbDate 包含的所有方法
         
         > showClass("SdbDate")
         SdbDate's static functions:
            help()
         SdbDate's member functions:
            help()
            toString()
         Takes 0.000218s.
