---
title: $LIST_SVCTASKS
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1565839755-edition_id-304
---

服务任务列表可以列出当前数据库节点中所有的服务任务。

## 标识

$LIST_SVCTASKS

## 字段信息

字段名 | 类型 | 描述  
---|---|---  
NodeName | string | 任务所在的节点  
TaskID | int32 | 任务 ID  
TaskName | string | 任务名称  
  
## 示例

查看服务任务列表
    
    
    > db.exec( "select * from $LIST_SVCTASKS" )

输出结果如下：
    
    
    {
      "NodeName": "hostname:30000",
      "TaskID": 0,
      "TaskName": "Default"
    }
    {
      "NodeName": "hostname:30010",
      "TaskID": 0,
      "TaskName": "Default"
    }
    ...
