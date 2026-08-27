---
title: dropDomain()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190779-edition_id-304
---

## 名称

dropDomain - 删除域

## 语法

**db.dropDomain( <name>)**

## 类别

Sdb

## 描述

该函数用于删除指定域。

## 参数

参数名 | 类型 | 描述 | 是否必填  
---|---|---|---  
name | string | 域名 | 是  
  
> **Note:**
> 
>   * dropDomain() 函数的定义格式必须指定 name 参数，并且 name 的值在系统中存在，否则操作异常。
>   * 删除域前必须保证域中不存在任何数据。
>   * 不支持删除系统域 SYSDOMAIN。
> 

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

  * 删除一个已存在的域
        
        > db.dropDomain('mydomain')

  * 删除一个包含集合空间的域，返回错误：
        
        > db.dropDomain('hello')
        (nofile):0 uncaught exception: -256
        > getLastErrMsg(-256)
        Domain is not empty
