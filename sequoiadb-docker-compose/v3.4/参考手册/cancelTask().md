---
title: cancelTask()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190769-edition_id-304
---

## 名称

cancelTask - 取消后台任务

## 语法

**db.cancelTask( <id>, [isAsync])**

## 类别

Sdb

## 描述

该函数用于取消后台任务。

## 参数

  * id（ _number，必填_ ）

任务 ID

  * isAsync（ _boolean，选填_ ）

是否以异步方式取消任务，默认值为 false，表示同步取消任务

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`cancelTask()` 函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-173 | SDB_CAT_TASK_NOTFOUND | 任务不存在 | 使用 [listTasks()](/cn/sequoiadb-cat_id-1432190800-edition_id-304) 检查任务是否存在  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.4 及以上版本

## 示例

以异步方式取消切分任务
    
    
    > var taskid1 = db.sample.employee.splitAsync("group1", "group2", 50)
    > db.cancelTask(taskid1, true)
