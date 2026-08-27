---
title: listTasks()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190800-edition_id-304
---

## 名称

listTasks - 枚举后台任务

## 语法

**db.listTasks( [cond], [sel], [sort], [hint] )**

## 类别

Sdb

## 描述

该函数用于枚举数据库所有后台任务。

## 参数

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
cond | Json 对象 | 任务过滤条件 | 否  
sel | Json 对象 | 任务选择字段 | 否  
sort | Json 对象 | 对返回的记录按选定的字段排序。1为升序；-1为降序。 | 否  
hint | Json 对象 | 保留项 | 否  
  
## 返回值

函数执行成功时，将返回游标对象。通过游标对象获取的结果字段说明可查看 [SYSTASKS 集合](/cn/sequoiadb-cat_id-1519625795-edition_id-304)

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

  * 列出系统所有后台任务
        
        > db.listTasks()
