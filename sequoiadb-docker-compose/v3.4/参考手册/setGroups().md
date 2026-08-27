---
title: setGroups()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1524019943-edition_id-304
---

## 名称

setGroups - 修改域包含的复制组

## 语法

**domain.setGroups( <options>)**

## 类别

SdbDomain

## 描述

该函数用于修改域包含的复制组。

## 参数

options ( _object，必填_ )

通过参数 options 可以修改域包含的复制组：

  * Groups ( _string/array_ )：域包含的复制组

修改域包含的复制组时，如果涉及删除复制组操作，需保证该复制组中不存在数据，否则操作报错。

格式：`Groups: ['group1', 'group2']`

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`setGroups()` 函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-154 | SDB_CLS_GRP_NOT_EXIST | 复制组不存在 | 使用列表查看复制组是否存在  
-256 | SDB_DOMAIN_IS_OCCUPIED | 域已被使用 | 使用 [listCollectionSpaces()](/cn/sequoiadb-cat_id-1432190887-edition_id-304) 查看域是否存在集合空间  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.4 及以上版本

## 示例

  * 创建一个包含复制组 group1 和 group2 的域，复制组中不存在数据
        
        > var domain = db.createDomain('mydomain', ['group1', 'group2'])

将域包含的复制组修改为 group1 和 group3
        
        > domain.setGroups({Groups: ['group1', 'group3']})

  * 创建一个包含复制组 group1 的域，复制组中存在数据
        
        > var domain = db.createDomain('mydomain', ['group1'])

将域包含的复制组修改为 group2
        
        > domain.setGroups({Groups: ['group2']})

由于 group1 中存在数据，操作报错
        
        (nofile):0 uncaught exception: -256
        Domain has been used
