---
title: $gte
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190901-edition_id-304
---

## 语法
    
    
    { <字段名>: { $gte: <值> } }

## 描述

$gte 选择满足“<字段名>”的值大于等于（>=）指定“<值>”的记录。

## 示例

  * 选择查询集合 sample.employee 中字段名为 age 的值大于等于 20 的记录
        
        > db.sample.employee.find( { age: { $gte: 20 } } )

  * $gte 匹配嵌套对象中的字段名，使用 update() 方法更新嵌套对象 service 中的 ID 字段值大于等于 2 的记录，将这些记录的 age 字段值设定为 25
        
        > db.sample.employee.update( { $set: { age: 25 } }, { "service.ID" : { $gte: 2 } } )
