---
title: delUser
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1560930351-edition_id-304
---

## 名称

delUser - 删除操作系统用户

## 语法

**System.delUser( <users>)**

## 类别

System

## 描述

该函数用于删除操作系统用户。

## 参数

users（ _object，必填_ ）

通过参数 users 可以设置需要删除的用户：

  * name（ _string_ ）：用户名，该参数必填

格式：`name: "username"`

  * isRemoveDir（ _boolean_ ）：是否删除用户目录，默认为 false

格式：`isRemoveDir: true`

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

删除指定的系统用户
    
    
    > System.delUser({name: "newUser"})
