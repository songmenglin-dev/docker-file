---
title: $LIST_USER
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1565839756-edition_id-304
---

用户列表可以列出当前集群中的所有用户信息。

## 标识

$LIST_USER

## 字段信息

字段名 | 类型 | 描述  
---|---|---  
User | string | 用户名  
Options.AuditMask | string | 用户审计日志配置掩码  
  
## 示例

查看用户列表
    
    
    > db.exec( "select * from $LIST_USER" )

输出结果如下：
    
    
    {
      "User": "admin",
      "Options": {}
    }
    {
      "User": "user2",
      "Options": {
        "AuditMask": "DDL|DML|!DQL"
      }
    }
