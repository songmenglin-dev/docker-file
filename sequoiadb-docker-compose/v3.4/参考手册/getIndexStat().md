---
title: getIndexStat()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1595582798-edition_id-304
---

## 名称

getIndexStat - 获取指定索引的统计信息

## 语法

**db.collectionspace.collection.getIndexStat( <index name>, [detail])**

## 类别

SdbCollection

## 描述

该函数用于获取当前集合中指定索引的统计信息。

## 参数

  * index name ( _string，必填_ )

被指定索引的名称

  * detail ( _boolean，选填_ )

是否获取索引的详细信息，默认值为 false，表示不获取

    * 详细信息将返回索引的频繁数值集合（Most Common Values，MCV）统计信息
    * 仅在 SequoiaDB v3.4.8 及以上版本中生效

## 返回值

函数执行成功时，将返回一个 BSONObj 类型的对象。通过该对象获取汇总后的索引统计信息，字段说明可参考[索引统计信息快照](/cn/sequoiadb-cat_id-1592467466-edition_id-304)。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`getIndexStat()` 函数常见异常如下：

错误码 | 错误名 | 可能发生的原因 | 解决办法  
---|---|---|---  
-356 | SDB_IXM_STAT_NOTEXIST | 1.索引尚未被统计  
2.索引不存在 | 1.通过 [db.analyze()](/cn/sequoiadb-cat_id-1496923440-edition_id-304) 接口收集统计信息  
2.检查索引是否存在  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.4.2 及以上版本

## 示例

获取集合 sample.employee 中 ageIndex 索引的统计信息
    
    
    > db.sample.employee.getIndexStat("ageIndex")

输出结果如下：
    
    
    {
      "Collection": "sample.employee",
      "Index": "ageIndex",
      "Unique": false,
      "KeyPattern": {
        "age": 1
      },
      "TotalIndexLevels": 1,
      "TotalIndexPages": 2,
      "DistinctValNum": [
        74
      ],
      "MinValue": {
        "age": 18
      },
      "MaxValue": {
        "age": 54
      },
      "NullFrac": 0,
      "UndefFrac": 0,
      "SampleRecords": 400,
      "TotalRecords": 518,
      "StatTimestamp": "2020-07-24-16.15.08.347000"
    }
