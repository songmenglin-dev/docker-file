---
title: list collections
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190958-edition_id-304
---

枚举数据库中所有的集合。

## 语法

**_list collections_**

## 参数

无

## 返回值

数据库中所有的集合。

## 示例

  * 返回数据库所有的集合。
        
        > db.exec("list collections") 
        { "Name": "sample.employee" }
        { "Name": "sample.employee2" }
        Return 2 row(s).
        Takes 0.4929s.
