---
title: $not
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190913-edition_id-304
---

## 语法
    
    
    { $not: [ { <表达式1> }, { <表达式2> }, ... } ] }

## 描述

$not 是一个逻辑“非”操作，用于选择不匹配表达式（ [ <表达式1>, <表达式2>, ... ] ）的记录。只要不满足其中的任意一个表达式，记录就会返回。

## 示例

  * 查询集合 sample.employee 下 age 字段值不等于 20 或 price 字段值不小于 10 的记录
        
        > db.sample.employee.find( { $not: [ { age: 20 }, { price: { $lt: 10 } } ] } )
