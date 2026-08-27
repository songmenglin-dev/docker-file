---
title: exist()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1552034485-edition_id-304
---

## 名称

exist - 判断文件是否存在

## 语法

**File.exist( <filepath>)**

## 类别

File

## 描述

判断文件是否存在。

## 参数

参数名 | 参数类型 | 默认值 | 描述 | 是否必填  
---|---|---|---|---  
filepath | string | \--- | 文件路径 | 是  
  
## 返回值

文件存在则返回 true，不存在则返回 false。

## 错误

如果出错则抛异常，并输出错误信息，可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息或通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。 关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

判断文件是否存在
    
    
    > File.exist( "/opt/sequoiadb/file.txt" )
    false
