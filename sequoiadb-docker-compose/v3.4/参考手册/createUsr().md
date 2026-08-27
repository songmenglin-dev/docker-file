---
title: createUsr()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190777-edition_id-304
---

## 名称

createUsr - 创建数据库用户

## 语法

**db.createUsr( <name>, <password>, [options])**

**db.createUsr( <User>, [options])**

**db.createUsr( <CipherUser>, [options])**

## 类别

Sdb

## 描述

该函数用于创建数据库用户，防止非法用户操作数据库。

## 参数

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
name | string | 用户名 | 是  
password | string | 密码 | 是  
User | object | [User](/cn/sequoiadb-cat_id-1591345466-edition_id-304) 对象 | 是  
CipherUser | object | [CipherUser](/cn/sequoiadb-cat_id-1591345553-edition_id-304) 对象 | 是  
options | Json | 扩展选项 | 否  
  
### options 取值

选项名称 | 取值类型 | 描述  
---|---|---  
AuditMask | String | 用户[审计日志](/cn/sequoiadb-cat_id-1601022446-edition_id-304)的配置掩码，默认值为"SYSTEM|DDL|DCL"，取值如下：  
ACCESS、CLUSTER、SYSTEM、DCL、DDL、DML、DQL、INSERT、UPDATE、DELETE、OTHER、ALL、NONE  
● 支持使用按位或（|）连接多个掩码，逻辑非（!）禁止某个掩码  
● 取值"ALL"表示选择全部配置掩码  
● 取值"NONE"表示禁止全部配置掩码，即关闭审计功能  
Role | String | 用户角色，当前只支持系统内置角色，默认值为 "admin"，取值列表："admin"、"monitor"。"admin" 为管理员角色，可执行任何操作；"monitor" 为监控角色，只能执行 snapshot 和 list 操作  
  
> **Note:**
> 
>   * 该接口只能用于集群模式。
>   * 当数据库创建了用户，连接数据库必须指定用户名和密码。
>   * 数据库用户名和密码的限制请参考[数据库限制](/cn/sequoiadb-cat_id-1432190984-edition_id-304#%E6%95%B0%E6%8D%AE%E5%BA%93)。
>   * 数据库中创建的第一个用户必须是"admin"角色。
> 

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

  * 创建用户名为 sdbadmin，密码为 sdbadmin 的用户，并设置审计日志掩码。
        
        > db.createUsr("sdbadmin", "sdbadmin", {AuditMask: "DDL|DML|!DQL"})

  * 使用 User 对象创建用户名为 sdbadmin，密码为 sdbadmin 的用户。
        
        > var a = User("sdbadmin", "sdbadmin")
        > db.createUsr(a)

  * 使用 CipherUser 对象创建用户名为 sdbadmin，密码为 sdbadmin 的用户（密文文件中必须存在用户名为 sdbadmin，密码为 sdbadmin 的用户信息，关于如何在密文文件中添加删除密文信息，详细可见 [sdbpasswd](/cn/sequoiadb-cat_id-1541583490-edition_id-304)）。
        
        > var a = CipherUser("sdbadmin")
        > db.createUsr(a)
