---
title: disableSharding()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1524019501-edition_id-304
---

## 名称

disableSharding - 修改集合的属性关闭分区功能

## 语法

**db.collectionspace.collection.disableSharding()**

## 类别

SdbCollection

## 描述

该函数用于修改集合的属性关闭分区功能。

## 参数

无

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`disableSharding()`函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-32 | SDB_OPTION_NOT_SUPPORT | 选项暂不支持 | 检查当前集合属性，如果是分区集合不能修改与分区相关的属性  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.10 及以上版本

## 示例

创建一个分区集合，然后将该集合的分区功能关闭
    
    
    > db.sample.createCL('employee', {ShardingKey: {a: 1}, ShardingType: 'hash'})
    > db.sample.employee.disableSharding()
