---
title: $rename
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1614933217-edition_id-304
---

## 语法
    
    
    { $rename: { <name>:<newname>[,<name>:<newname>, ... ]} }

## 描述

$rename 操作符是将字段名 name 重命名为字段名 newname。

## 示例

  * 集合 sample.employee 存在如下记录：
        
        { "a": 5,"b": 10 }

将字段名 a 重命名为字段名 c，将字段名 b 重命名为字段名 d：
        
        > db.sample.employee.update({$rename:{'a':'c','b':'d'}})

此操作后，记录更新为：
        
        { "c": 5,"d": 10 }
