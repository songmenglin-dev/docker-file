---
title: getIniConfigs()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1580718032-edition_id-304
---

## 名称

getIniConfigs - 获取 INI 文件的配置信息。

## 语法

**Oma.getIniConfigs( <configPath>, [options])**

## 类别

Oma

## 描述

获取 INI 文件的配置信息。

## 参数

  * `configPath` ( _String_ , _必填_ )

INI 配置文件的路径。

  * `options` ( _Object_ , _选填_ )

解析配置文件的参数项.

EnableType: true 是开启数据类型, false 是所有类型都视为字符串, 默认 false.

StrDelimiter: true 是字符串只支持双引号, false 是字符串只是双引号和单引号, 默认 true.

## 返回值

成功：返回 BSONObj 对象，该对象包含 INI 文件的配置信息。

失败：抛出异常。

## 错误

`getIniConfigs()`函数常见异常如下：

错误码 | 错误类型 | 描述 | 解决方法  
---|---|---|---  
-4 | SDB_FNE | 文件不存在 | 确认输入的 INI 配置文件是否存在。  
  
当异常抛出时，可以通过 [getLastError()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)， 或通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息。 可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)了解更多内容。

## 版本

v3.0.2及以上版本。

## 示例

  1. 打印 INI 配置文件。
         
         > Oma.getIniConfigs( "/opt/config.ini" )
         {
             "datestyle": "iso, ymd",
             "listen_addresses": "*",
             "log_timezone": "PRC",
             "port": "1234",
             "shared_buffers": "128MB",
             "timezone": "PRC"
         }

  2. 打印 INI 配置文件，并且开启数据类型。
         
         > Oma.getIniConfigs( "/opt/config.ini", { "EnableType": true } )
         {
             "datestyle": "iso, ymd",
             "listen_addresses": "*",
             "log_timezone": "PRC",
             "port": 1234,
             "shared_buffers": "128MB",
             "timezone": "PRC"
         }
