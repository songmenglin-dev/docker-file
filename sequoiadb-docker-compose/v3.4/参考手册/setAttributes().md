---
title: setAttributes()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1524019772-edition_id-304
---

## 名称

setAttributes - 修改集合空间的属性

## 语法

**db.collectionspace.setAttributes( <options>)**

## 类别

SdbCS

## 描述

该函数用于修改集合空间的属性。

## 参数

options ( _object，必填_ )

通过 options 参数可以修改集合空间属性：

  * PageSize ( _number_ )：数据页大小，单位为字节

    * PageSize 只能选填 0、4096、8192、16384、32768、65536 之一
    * PageSize 为 0 时，即默认值 65536
    * 修改时不能有数据

格式：`PageSize: <number>`

  * LobPageSize ( _number_ )：LOB 数据页大小，单位为字节

    * LobPageSize 只能选填 0、4096、8192、16384、32768、65536、131072、262144、524288 之一
    * LobPageSize 为 0 时，即默认值 262144
    * 修改时不能有 LOB 数据

格式：`LobPageSize: <number>`

  * Domain ( _string_ )：所属域

集合空间的数据必须分布在新指定域的组上

格式：`Domain: <domain>`

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`setAttributes()` 函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-32 | SDB_OPTION_NOT_SUPPORT | 选项暂不支持 | 检查当前集合空间属性是否支持  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.10 及以上版本

## 示例

  * 创建一个集合空间，数据页大小为 4096，然后将该集合空间的数据页大小修改为 8192
        
        > db.createCS('sample', {PageSize: 4096})
         > db.sample.setAttributes({PageSize: 8192})

  * 创建一个集合空间，然后为该集合空间指定一个域
        
        > db.createCS('sample')
        > db.sample.setAttributes({Domain: 'domain'})
