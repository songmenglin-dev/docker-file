---
title: transaction
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1520813139-edition_id-304
---

事务操作。

## 语法

开启事务： **_begin transaction_**

提交事务： **_commit_**

回滚事务： **_rollback_**

## 参数

无

## 返回值

无 

## 示例

  * 开启事务，插入记录，提交事务 
        
        > db.execUpdate( "begin transaction" )
        > db.execUpdate( "insert into sample.employee(name) values(\"Tom\")" )
        > db.execUpdate( "commit" )

  * 开启事务，插入记录，回滚事务 
        
        > db.execUpdate( "begin transaction" )
        > db.execUpdate( "insert into sample.employee(name) values('Tom')" )
        > db.execUpdate( "rollback" )
