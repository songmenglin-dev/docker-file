---
title: waitTasks()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190818-edition_id-304
---

## 名称

waitTasks - 同步等待指定任务结束或取消

## 语法

**db.waitTasks( <id1>, [id2], ...)**

## 类别

Sdb

## 描述

该函数用于同步等待指定任务结束或取消。

## 参数

参数名 | 类型 | 描述 | 是否必填  
---|---|---|---  
id1, id2… | number | 任务 ID | 是  
  
## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

同步等待数据切分任务完成
    
    
    > var taskid1 = db.test.test.splitAsync("db1", "db2", 50);
    > var taskid2 = db.my.my.splitAsync("db3", "db4", 50) ;
    > db.waitTasks(taskid1, taskid2)
