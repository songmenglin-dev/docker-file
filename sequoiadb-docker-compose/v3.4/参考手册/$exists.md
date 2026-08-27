---
title: $exists
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190916-edition_id-304
---

## 语法
    
    
    { <字段名>: { $exists: <0|1> } }

## 描述

匹配集合中是否存在指定“<字段名>”的记录。

值 | 作用  
---|---  
0 | 匹配“<字段名>”不存在的记录  
1 | 匹配“<字段名>”存在的记录  
  
## 示例

  * 选择集合 sample.employee 中存在字段 age 的记录
        
        > db.sample.employee.find( { "age": { "$exists": 1 } } )

  * 选择集合 sample.employee 中嵌套对象 content 不存在 name 字段的记录
        
        > db.sample.employee.find( { "content.name": { "$exists": 0 } } )
