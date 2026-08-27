---
title: $unset
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190925-edition_id-304
---

## 语法
    
    
    { $unset: { <字段名1>: "", <字段名2>: "", ... } }

## 描述

$unset 操作是删除集合中指定的字段名，如果记录中没有指定的字段名则跳过。

## 示例

  * 删除集合 sample.employee 下记录的 name 字段和 age 字段，如果记录中没有字段 name 或 age 则跳过，不做任何处理
        
        > db.sample.employee.update({ $unset: { name: "", age: "" } })

  * 集合 sample.employee 存在如下记录：
        
        { arr: [1,2,3], name: "Tom" }

使用 $unset 删除第二个元素
        
        > db.sample.employee.update({ $unset: { "arr.2": "" } })

此操作后，记录更新为
        
        { arr: [1,null,3], name: "Tom" }

  * 集合 sample.employee 存在如下记录：
        
        { content: { ID: 1, type: "system", position: "manager" }, name: "Tom" }

> **Note:**
> 
> content是一个嵌套对象，有ID、type 和 position 三个字段。

使用 $unset 删除 type 字段
        
        > db.sample.employee.update({ $unset: { "content.type": "" } })

此操作后，记录更新为
        
        { content: { ID: 1, position: "manager" }, name: "Tom" }
