---
title: $in
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190907-edition_id-304
---

## 语法
    
    
    { <字段名>: { $in: [ <值1>, <值2>, ... ] } }

## 描述

选择集合中“<字段名>”值匹配给定数组（ [ <值1>, <值2>, ... ] ）中任意一个值的记录；如果“<字段名>”本身是数组类型，那么只要满足“<字段名>”中任意一个值等于给定数组（ [ <值1>, <值2>, ... ] ）中值的记录都会返回。

## 示例

  * 查询集合 sample.employee 下 age 字段的值是 20 或 25 的记录
        
        > db.sample.employee.find( { age: { $in: [ 20, 25 ] } } )

  * $in 匹配嵌套数组对象中的元素，查询集合 sample.employee 中数组对象 name 存在元素“Tom”或“Mike”的记录，并将这些记录的 age 字段删除
        
        > db.sample.employee.update( { $unset: { age: "" } }, { name: { $in: [ "Tom", "Mike" ] } } )

  * 当给定数组只有一个值时，即 { <字段名>: { $in: [ <值> ] } }，等价于 { <字段名>: <值> }
        
        > db.sample.employee.find( { age: { $in: [ 20 ] } } )

等价于
        
        > db.sample.employee.find( { age: 20 } )
