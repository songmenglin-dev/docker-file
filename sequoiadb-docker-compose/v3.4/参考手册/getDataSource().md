---
title: getDataSource()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1610377717-edition_id-304
---

## 名称

getDataSource - 获取数据源的引用

## 语法

**db.getDataSource( <name> )**

## 类别

Sdb

## 描述

该函数用于获取数据源的引用，通过该引用可以对数据源的元数据信息进行修改。

## 参数

name（ _string_ ， _必填_ ）

数据源名称

## 返回值

函数执行成功时，将返回一个 DataSource 对象。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`getDataSource()` 函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-370 | SDB_CAT_DATASOURCE_NOTEXIST | 数据源不存在 | 检查是否存在指定数据源  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.2.8 及以上版本

## 示例

获取数据源 datasource 的引用
    
    
    > var ds = db.getDataSource("datasource")

修改该数据源的访问权限为“WRITE”
    
    
    > ds.alter({AccessMode:"WRITE"})
