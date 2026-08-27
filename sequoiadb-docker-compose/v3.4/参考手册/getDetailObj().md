---
title: getDetailObj()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1601192934-edition_id-304
---

## 名称

getDetailObj - 获取复制组的信息

## 语法

**rg.getDetailObj()**

## 类别

SdbReplicaGroup

## 描述

获取当前复制组的详细信息，复制组的详细信息可参考[数据分区列表](/cn/sequoiadb-cat_id-1479173738-edition_id-304)章节。

## 参数

无

## 返回值

函数执行成功时，返回当前复制组详细信息，其类型为 BSONObj。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.2.7 及以上版本

v3.4.2 及以上版本

## 示例

获取 group1 复制组的详细信息，该复制组存在 1 个节点。
    
    
    > var rg = db.getRG("group1")
    > rg.getDetailObj()

结果如下：
    
    
    {
      "Group": [
        {
          "HostName": "localhost",
          "Status": 1,
          "dbpath": "/opt/sequoiadb/database/data/11830/",
          "Service": [
            {
              "Type": 0,
              "Name": "11830"
            },
            {
              "Type": 1,
              "Name": "11831"
            },
            {
              "Type": 2,
              "Name": "11832"
            }
          ],
          "NodeID": 1002
        }
      ],
      "GroupID": 1001,
      "GroupName": "group1",
      "PrimaryNode": 1004,
      "Role": 0,
      "Status": 1,
      "Version": 7,
      "_id": {
        "$oid": "580043577e70618777a2cf39"
      }
    }
