---
title: listDataSources()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1610377810-edition_id-304
---

## 名称

listDataSources - 查看数据源的元数据信息

## 语法

**db.listDataSources( [cond], [sel], [sort] )**

## 类别

Sdb

## 描述

该函数用于查看数据源的服务地址、访问权限、数据源版本号、数据源类型等元数据信息。

## 参数

参数名 | 类型 | 描述 | 是否必填  
---|---|---|---  
cond | Json 对象 | 匹配条件，只返回符合 cond 的记录，为 null 时，返回所有记录 | 否  
sel | Json 对象 | 选择返回的字段名。为 null 时，返回所有的字段名 | 否  
sort | Json 对象 | 对返回的记录按选定的字段排序，1 为升序，-1为降序 | 否  
  
## 返回值

函数执行成功时，将返回一个 SdbCursor 类型的对象。通过该对象获取数据源的元数据信息，字段说明可参考 [SYSCAT.SYSDATASOURCES 集合](/cn/sequoiadb-cat_id-1610373493-edition_id-304)。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.2.8 及以上版本

## 示例

查看数据源的元数据信息
    
    
    > db.listDataSources()

输出结果如下：
    
    
    {
      "_id": {
        "$oid": "5ffc365c72e60c4d9be30c50"
      },
      "ID": 2,
      "Name": "datasource",
      "Type": "SequoiaDB",
      "Version": 0,
      "DSVersion": "3.4.1",
      "Address": "sdbserver:11810",
      "User": "sdbadmin",
      "Password": "d41d8cd98f00b204e9800998ecf8427e",
      "ErrorControlLevel": "low",
      "AccessMode": 1,
      "AccessModeDesc": "READ",
      "ErrorFilterMask": 0
      "ErrorFilterMaskDesc": "NONE"
    }
