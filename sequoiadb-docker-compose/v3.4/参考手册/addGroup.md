---
title: addGroup
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1560930347-edition_id-304
---

## 名称

addGroup - 添加用户组

## 语法

**System.addGroup( <groups> )**

## 类别

System

## 描述

添加用户组

## 参数

参数名 | 参数类型 | 默认值 | 描述 | 是否必填  
---|---|---|---|---  
groups | JSON | \--- | 用户组信息 | 是  
  
groups 参数详细说明如下：

属性 | 值类型 | 是否  
必填 | 格式 | 描述  
---|---|---|---|---  
name | string | 是 | { "name": newGroup } | 用户组名  
  
## 返回值

无返回值。

## 错误

如果出错则抛异常，并输出错误信息，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

增加一个用户组
    
    
    > System.addGroup( { "name": "newGroup" } )
