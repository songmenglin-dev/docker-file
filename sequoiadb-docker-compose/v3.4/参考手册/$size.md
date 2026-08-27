---
title: $size
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1477878011-edition_id-304
---

## 语法
    
    
    { <字段名>: { $size: 1 } }

## 说明

返回数组或对象 Object 的元素个数。

## 示例

在集合 sample.employee 插入如下记录：
    
    
    > db.sample.employee.insert( { "a": [ 1, 2, 3 ] } )

  * 作为选择符使用，返回字段 a 数组元素个数
        
        > db.sample.employee.find( {}, { "a": { "$size": 1 } } )
        {
          "_id": {
            "$oid": "582575dd2b4c38286d000022"
          },
          "a": 3
        }
        Return 1 row(s).

> **Note:**
> 
> { $size: 1 } 中 1 没有特殊含义，仅作为占位符出现。

  * 与匹配符配合使用，匹配字段 a 数组元素个数为 3 的记录
        
        > db.sample.employee.find( { "a": { "$size": 1, "$et": 3 } } )
        {
          "_id": {
            "$oid": "582575dd2b4c38286d000022"
          },
          "a": [
            1,
            2,
            3
          ]
        }
        Return 1 row(s).
