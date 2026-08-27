---
title: $LIST_CL
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1559282953-edition_id-304
---

集合列表可以列出当前集群中的集合信息。连接协调节点执行函数时，将列出所有非系统集合的信息；连接非协调节点执行函数时，将列出与当前节点关联的所有集合信息。每个集合为一条记录。

## 标识

$LIST_CL

## 字段信息

字段名 | 类型 | 描述  
---|---|---  
Name | string | 集合完整名  
UniqueID | int64 | 集合的 UniqueID，在集群上全局唯一  
Version | int32 | 集合的版本号，由 1 起始，每次对该集合的元数据变更会造成版本号 +1  
Attribute | int32 | 集合的属性掩码，取值可参考 [SYSCOLLECTION 集合](/cn/sequoiadb-cat_id-1519625791-edition_id-304)  
AttributeDesc | string | 集合的属性描述，取值可参考 [SYSCOLLECTION 集合](/cn/sequoiadb-cat_id-1519625791-edition_id-304)  
CompressionType | int32 | 压缩算法类型掩码，取值可参考 [SYSCOLLECTION 集合](/cn/sequoiadb-cat_id-1519625791-edition_id-304)  
CompressionTypeDesc | string | 压缩算法类型描述，取值可参考 [SYSCOLLECTION 集合](/cn/sequoiadb-cat_id-1519625791-edition_id-304)  
CataInfo | array | 集合所在的逻辑节点信息  
  
## 示例

查看集合列表
    
    
    > db.exec("select * from $LIST_CL")

输出结果如下：
    
    
    {
      "_id": {
        "$oid": "5cf4b6a307c2e1754b77c5ef"
      },
      "Name": "sample.employee",
      "UniqueID": 2469606195201,
      "Version": 1,
      "Attribute": 1,
      "AttributeDesc": "Compressed",
      "CompressionType": 1,
      "CompressionTypeDesc": "lzw",
      "CataInfo": [
        {
          "GroupID": 1001,
          "GroupName": "db2"
        }
      ]
    }
    ...
