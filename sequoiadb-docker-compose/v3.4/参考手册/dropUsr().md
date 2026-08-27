---
title: dropUsr()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190780-edition_id-304
---

## 名称

dropUsr - 删除数据库用户

## 语法

**db.dropUsr( <name>, <password> )**

**db.dropUsr( <User> )**

**db.dropUsr( <CipherUser> )**

## 类别

Sdb

## 描述

该函数用于删除数据库用户。

## 参数

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
name | string | 用户名 | 是  
password | string | 密码 | 是  
User | object | [User](/cn/sequoiadb-cat_id-1591345466-edition_id-304) 对象 | 是  
CipherUser | object | [CipherUser](/cn/sequoiadb-cat_id-1591345553-edition_id-304) 对象 | 是  
  
> **Note:**
> 
>   * 在删除最后一个角色为 "admin" 的用户时，需要确保已经没有角色为 "monitor" 的用户存在，否则删除会失败
> 

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

  * 删除用户名为 sdbadmin，密码为 sdbadmin 的用户。
        
        > db.dropUsr( "sdbadmin", "sdbadmin" )

  * 使用 User 对象删除用户名为 sdbadmin，密码为 sdbadmin 的用户。
        
        > var a = User( "sdbadmin", "sdbadmin" )
        > db.dropUsr( a )

  * 使用 CipherUser 对象删除用户名为 sdbadmin，密码为 sdbadmin 的用户（密文文件中必须存在用户名为 sdbadmin，密码为 sdbadmin 的用户信息，关于如何在密文文件中添加删除密文信息，详细可见[sdbpasswd](/cn/sequoiadb-cat_id-1541583490-edition_id-304)）。
        
        > var a = CipherUser( "sdbadmin" )
        > db.dropUsr( a )
