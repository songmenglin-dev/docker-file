---
title: limit
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190966-edition_id-304
---

limit 用于限制返回记录个数。

## 语法

**_limit <limit_num>_**

## 参数

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
limit_num | int32 | 限制返回的记录数 | 是  
  
## 返回值

无 

## 示例

  * 集合 sample.employee 中原始记录如下：
        
        {a:0, b:2}
        {a:1, b:2}
        {a:2, b:3}
        {a:3, b:3}

  * 返回集合中前 2 条记录 
        
        > db.exec("select * from sample.employee limit 2")
        { "_id": { "$oid": "58297592fa75cf402400000b" }, "a": 0, "b": 2 }
        { "_id": { "$oid": "58297592fa75cf402400000c" }, "a": 1, "b": 2 }
        Return 2 row(s).
