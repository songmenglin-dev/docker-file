---
title: list collectionspaces
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190957-edition_id-304
---

list collectionspaces 枚举数据库中所有的集合空间。

## 语法

**_list collectionspaces_**

## 参数

无

## 返回值

数据库中所有的集合空间。

## 示例

返回数据库所有的集合空间
    
    
    > db.exec("list collectionspaces") 
    { "Name": "sample" }
    Return 1 row(s).
