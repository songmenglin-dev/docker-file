---
title: listIndexes()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190840-edition_id-304
---

## 名称

listIndexes - 列举集合中的索引信息

## 语法

**db.collectionspace.collection.listIndexes()**

## 类别

SdbCollection

## 描述

该函数用于列举指定集合中所有[索引](/cn/sequoiadb-cat_id-1432190613-edition_id-304)的信息。用户通过协调节点执行该函数，将从编目节点获取索引信息；通过数据节点执行该函数，将从该数据节点获取索引信息。

## 参数

无

## 返回值

函数执行成功时，将返回一个 SdbCursor 类型的对象。通过该对象获取索引详细信息列表，字段说明如下：

字段名 | 类型 | 描述  
---|---|---  
name | string | 索引名  
key | json | 索引键，取值如下：  
1：按字段升序  
-1：按字段降序  
"text"：[全文索引]()  
v | int32 | 索引版本号  
unique | boolean | 索引是否唯一，取值如下：   
"true"：唯一索引，不允许集合中有重复的值   
"false"：普通索引，允许集合中有重复的值  
enforced | boolean | 索引是否强制唯一，取值如下：  
"false"：不强制唯一  
"true"：强制唯一，即不允许存在一个以上全空的索引键  
NotNull | boolean | 索引的任意一个字段是否允许为 null 或者不存在，取值如下：   
"true"：不允许为 null 或者不存在   
"false"：允许为 null 或不存在  
IndexFlag | string | 索引当前状态，取值如下：   
"Normal"：正常   
"Creating"：正在创建   
"Dropping"：正在删除   
"Truncating"：正在清空   
"Invalid"：无效  
Type | string | 索引类型，取值如下：   
"Positive"：正序索引   
"Reverse"：逆序索引   
"Text"：全文索引  
NotArray | boolean | 索引的任意一个字段是否允许为数组，取值如下：   
"true"：不允许为数组   
"false"：允许为数组  
Global | boolean | 是否为全局索引（内部使用）  
dropDups | boolean | 是否自动删除相同的键值（内部使用）  
  
函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.4 及以上版本

## 示例

列举集合 sample.employee 中所有索引的信息
    
    
    > db.sample.employee.listIndexes()
    {
      "IndexDef": {
        "name": "$id",
        "_id": {
          "$oid": "5e9e91bccf4f1e7370e4074d"
        },
        "key": {
          "_id": 1
        },
        "v": 0,
        "unique": true,
        "dropDups": false,
        "enforced": true,
        "NotNull": false，
        "NotArray": false
        "Global": false
      },
      "IndexFlag": "Normal",
      "Type": "Positive"
    }
