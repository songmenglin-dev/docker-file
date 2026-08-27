---
title: enableCompression()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1524019502-edition_id-304
---

## 名称

enableCompression - 开启集合的压缩功能或者修改集合的压缩算法

## 语法

**db.collectionspace.collection.enableCompression([options])**

## 类别

SdbCollection

## 描述

该函数用于开启集合的压缩功能或者修改集合的压缩算法。

## 参数

options ( _object，选填_ )

通过 options 参数可以修改压缩算法类型：

  * CompressionType ( _string_ )：集合的压缩算法类型，默认为 lzw 算法。其可选取值如下：

    * "lzw"：使用 lzw 算法压缩
    * "snappy"：使用 snappy 算法压缩

格式：`CompressionType: "lzw" | "snappy"`

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`enableCompression()`函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-32 | SDB_OPTION_NOT_SUPPORT | 选项暂不支持 | 检查当前集合属性，如果是分区集合不能修改与分区相关的属性  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.10 及以上版本

## 示例

创建一个普通集合，然后将该集合修改为"snappy" 压缩
    
    
    > db.sample.createCL('employee')
    > db.sample.employee.enableCompression({CompressionType: 'snappy'})
