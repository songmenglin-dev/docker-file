---
title: listReplicaGroups()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190799-edition_id-304
---

## 名称

listReplicaGroups - 枚举复制组信息

## 语法

**db.listReplicaGroups()**

## 类别

Sdb

## 描述

该函数用于枚举复制组信息。

## 参数

无

## 返回值

函数执行成功时，将返回游标对象。通过游标对象获取的结果字段说明可查看 [$LIST_GROUP](/cn/sequoiadb-cat_id-1559282956-edition_id-304)

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

  * 返回所有复制组信息
        
        > db.listReplicaGroups()
        {
        "Group": 
        [
          {
            "dbpath": "/opt/sequoiadb/data/11800",
            "HostName": "vmsvr2-suse-x64",
            "Service": [
              {
                "Type": 0,
                "Name": "11800"
              },
              {
                "Type": 1,
                "Name": "11801"
              },
              {
                "Type": 2,
                "Name": "11802"
              },
              {
                "Type": 3,
                "Name": "11803"
              }
            ],
            "NodeID": 1000
          },
          {
            "dbpath": "/opt/sequoiadb/data/11850",
            "HostName": "vmsvr2-suse-x64",
            "Service": [
              {
                "Type": 0,
                "Name": "11850"
              },
              {
                "Type": 1,
                "Name": "11851"
              },
              {
                "Type": 2,
                "Name": "11852"
              },
              {
                "Type": 3,
                "Name": "11853"
              }
            ],
            "NodeID": 1001
          }
        ],
        "GroupID": 1001,
        "GroupName": "group",
        "PrimaryNode": 1001,
        "Role": 0,
        "Status": 1,
        "Version": 5,
        "_id": {
          "$oid": "517b2fc33d7e6f820fc0eb57"
          }
        }

这个复制组有两个节点：11800和11850，其中11850为主节点。复制组详细信息请见[复制组列表](/cn/sequoiadb-cat_id-1479173738-edition_id-304)
