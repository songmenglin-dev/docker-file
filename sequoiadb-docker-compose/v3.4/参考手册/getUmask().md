---
title: getUmask()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1552034969-edition_id-304
---

## 名称

getUmask - 获取新建文件权限的掩码

## 语法

**File.getUmask([base])**

## 类别

File

## 描述

获取新建文件权限的掩码。

## 参数

参数名 | 参数类型 | 默认值 | 描述 | 是否必填  
---|---|---|---|---  
base | int | 10 | 进制数（八进制或者十进制或者十六进制） | 否  
  
## 返回值

返回新建文件权限的掩码。

## 错误

如果出错则抛异常，并输出错误信息，可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息或通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。 关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

获取新建文件权限的掩码
    
    
    > File.getUmask( 8 )    // 八进制
    0022
    > File.getUmask( 10 )   // 十进制
    18
    > File.getUmask( 16 )   // 十六进制
    0x12
