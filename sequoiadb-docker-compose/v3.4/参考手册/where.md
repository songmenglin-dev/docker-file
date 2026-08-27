---
title: where
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1520813394-edition_id-304
---

where 用于过滤记录。

## 语法

**_where <comparison_expression>_**

## 参数

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
comparison_expression | expression | [比较表达式](/cn/sequoiadb-cat_id-1510279628-edition_id-304#%E6%AF%94%E8%BE%83%E8%A1%A8%E8%BE%BE%E5%BC%8F) | 是  
  
## 示例

  * 集合 sample.employee 中存在如下记录:
        
        { "name": "Lucy", "age": 11 }
        { "name": "Sam", "age": 8 }
        { "name": "Tom", "age": 7 }
        { "name": "James", "age": 12 }

  * 查询匹配集合中 age 大于 10 的记录
        
        > db.exec("select * from sample.employee where age > 10")
        { "name": "Lucy", "age": 11 }
        { "name": "James", "age": 12 }
        Return 2 row(s).
