---
title: User
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1591345466-edition_id-304
---

User 对象，该对象是为了保存用户名和密码。可直接用于 new Sdb、createUsr 和 dropUsr 接口中，代替原有的用户名和密码的输入。

## 语法

**User( <username>, [passwd] )**

**User( <username> ).promptPassword()**

## 方法

**User( <username>, [passwd] )**

创建 User 对象

参数名 | 参数类型 | 默认值 | 描述 | 是否必填  
---|---|---|---|---  
username | string | \--- | 用户名 | 是  
passwd | string | null | 密码 | 否  
  
**promptPassword()**

通过交互式界面提示用户输入密码（输入的密码不可见）

**getUsername()**

获取用户名

**toString()**

把 User 对象以字符串的形式输出

## 错误

如果出错则抛异常，并输出错误信息，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。 关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 示例

  1. 创建 User 对象
         
         > var a = User( "sdbadmin" )

  2. 交互式界面输入密码
         
         > a.promptPassword()
         password:
         sdbadmin

  3. 获取用户名
         
         > a.getUsername()
         sdbadmin

  4. 将 User 对象以字符串的形式输出
         
         > a.toString()
         sdbadmin
