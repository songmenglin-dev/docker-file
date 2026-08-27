---
title: next()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190852-edition_id-304
---

## 名称

next - 获取当前游标指向的下一条记录

## 语法

**cursor.next()**

## 类别

SdbCursor

## 描述

该函数用于获取当前游标指向的下一条记录，更多查看 [current()](/cn/sequoiadb-cat_id-1432190851-edition_id-304) 方法。

## 参数

无

## 返回值

函数执行成功时，如果游标有记录返回，返回值为 BSONObj 类型的对象；否则，返回值为 null 类型的对象。

函数执行失败时，将抛异常并输出错误信息。

## 错误

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-31 | SDB_DMS_CONTEXT_IS_CLOSE | 上下文已关闭 | 确认查询记录是否为 0 条  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.0 及以上版本

## 示例

选择集合 employee 下 age 大于 8 的记录，返回当前游标指向的下一条记录
    
    
    > var cur = db.sample.employee.find({age: {$gt: 8}})
    > var obj = cur.next();
    > if (obj == null) {
          println ("No record!");
      } else {
            println ("Record is:" + obj);
        }
      Record is:{
        "_id":{
          "$oid": "60470a4db354306ff89cd355"
        },
      "a": 9
      }
