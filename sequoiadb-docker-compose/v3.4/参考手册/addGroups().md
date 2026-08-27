---
title: addGroups()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1524019940-edition_id-304
---

## 名称

addGroups - 在域中新增复制组

## 语法

**domain.addGroups( <options>)**

## 类别

SdbDomain

## 描述

该函数用于在域中新增复制组。

> **Note:**
> 
> 新增复制组不影响域中原有集合的数据分布及属性，只对新建的集合有影响。

## 参数

options ( _object，必填_ )

通过 options 参数可以设定复制组的参数：

  * Groups ( _string/array_ )：新增的复制组

格式：`Groups: ['group1', 'group2']`

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`addGroups()` 函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-154 | SDB_CLS_GRP_NOT_EXIST | 分区组不存在 | 使用列表查看分区组是否存在  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

创建一个域，包含两个复制组，开启自动切分
    
    
    > var domain = db.createDomain('mydomain', ['group1', 'group2'], {AutoSplit: true})

  * 在域中新增复制组 group3
        
        > domain.addGroups({Groups: ['group3']})

  * 在域中新增复制组 group4 和 group5
        
        > domain.addGroups({Groups: ['group4', 'group5']})
