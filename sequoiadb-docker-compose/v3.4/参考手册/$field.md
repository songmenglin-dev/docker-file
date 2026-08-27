---
title: $field
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1589449292-edition_id-304
---

## 语法
    
    
    { $field: <字段名> }

## 描述

$field 是取字段符，用于取出指定字段的值，应用于其它操作，支持的操作包括：

  * 用于查询操作的匹配条件中，语法格式如下：
        
        { <字段名1>: { $field: <字段名2> }, ... }
        { <字段名1>: { <匹配符>: { $field: <字段名2> } }, ... }

  * 用于更新操作的更新规则中，支持的更新符包括 [$inc](/cn/sequoiadb-cat_id-1432190923-edition_id-304)、[$set](/cn/sequoiadb-cat_id-1432190924-edition_id-304)、[$pop](/cn/sequoiadb-cat_id-1432190927-edition_id-304)、[$pull](/cn/sequoiadb-cat_id-1432190928-edition_id-304)、[$pull_by](/cn/sequoiadb-cat_id-1503279322-edition_id-304) 及 [$push](/cn/sequoiadb-cat_id-1432190930-edition_id-304)，语法格式如下：
        
        { <更新符>: { <字段名1>: { $field: <字段名2> } } }

对于 $inc 操作，由于其值的部分还支持对象的形式，因此，还支持如下语法格式：
        
        { $inc: { <字段名1>: { Value: { $field: <字段名2> } [, Default: 默认值, Min: 最小值, Max: 最大值 ] } } }

## 示例

此处只举若干示例，更多示例请到各操作符章节查看。

集合 sample.employee 存在如下记录：
    
    
    { "t1": 100, "t2": 100 } 
    { "t1": 200, "t2": 150 }

  * 查询 sample.employee 中 t1 字段值等于 t2 字段的记录
        
        > db.sample.employee.find( { "t1": { "$field": "t2" } } )
        {
          "t1": 100,
          "t2": 100
        }

  * 查询 sample.employee 中 t1 字段值大于 t2 字段的记录
        
        > db.sample.employee.find( { "t1": { "$gt": { "$field": "t2" } } } )
        {
          "t1": 200,
          "t2": 150
        }

  * 将字段 t2 的值设置为与 t1 相同
        
        > db.sample.employee.update({ $set: { t2: { $field: "t1" } } })

该操作完成后，记录如下：
        
        { "t1": 100, "t2": 100 }
        { "t1": 200, "t2": 200 } 

  * 将字段 t2 的值累加至 t1
        
        > db.sample.employee.update({ $inc: { t1: { Value: { $field: "t2" } } } })

该操作完成后，记录如下：
        
        { "t1": 200, "t2": 100 }
        { "t1": 400, "t2": 200 }
