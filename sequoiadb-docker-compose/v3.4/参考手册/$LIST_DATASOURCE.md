---
title: $LIST_DATASOURCE
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1611220898-edition_id-304
---

数据源列表可以列出当前数据库中所有数据源的元数据信息。

## 标识

$LIST_DATASOURCE

## 字段信息

返回的字段信息可参考 [SYSCAT.SYSDATASOURCES 集合](/cn/sequoiadb-cat_id-1610373493-edition_id-304)。

## 示例

查看所有数据源的元数据信息
    
    
    > db.exec("select * from $LIST_DATASOURCE")

输出结果如下：
    
    
    {
      "_id": {
        "$oid": "5ffc365c72e60c4d9be30c50"
      },
      "ID": 2,
      "Name": "datasource",
      "Type": "SequoiaDB",
      "Version": 0,
      "DSVersion": "3.4.1",
      "Address": "sdbserver:11810",
      "User": "sdbadmin",
      "Password": "d41d8cd98f00b204e9800998ecf8427e",
      "ErrorControlLevel": "High",
      "AccessMode": 1,
      "AccessModeDesc": "READ",
      "ErrorFilterMask": 0
      "ErrorFilterMaskDesc": "NONE"
    }
