---
title: $isnull
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190909-edition_id-304
---

## 语法
    
    
    { <字段名>: { $isnull: <0|1> } }

## 描述

选择集合中指定的“<字段名>”是否为空，或不存在。

值 | 作用  
---|---  
0 | 返回字段存在且不为 null 的记录  
1 | 返回字段不存在或为 null 的记录  
  
## 示例

查询集合 sample.employee 中 age 字段不为空且存在的记录
    
    
    > db.sample.employee.find( { age: { $isnull: 0 } } )
