---
title: setIniConfigs()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1580718040-edition_id-304
---

## 名称

setIniConfigs - 把配置信息写入 INI 文件。

## 语法

**Oma.setIniConfigs( <config>, <configPath>, [options])**

## 类别

Oma

## 描述

把配置信息写入 INI 文件。

## 参数

  * `config` ( _Object_ , _必填_ )

配置信息。

  * `configPath` ( _String_ , _必填_ )

INI 配置文件的路径。

  * `options` ( _Object_ , _选填_ )

解析配置文件的参数项.

EnableType: true 是开启数据类型, false 是所有类型都视为字符串, 默认 false.

StrDelimiter: true 是字符串用双引号, false 是字符串用单引号, null 是不输出字符串分隔符, 默认 true.

## 返回值

成功：无。

失败：抛出异常。

## 版本

v3.0.2及以上版本。

## 示例

  1. 写入 INI 配置文件。
         
         > Oma.setIniConfigs( { "a": 1, "b": true, "c": "hello"}, "/opt/config.ini" )

  2. 写入 INI 配置文件，并且开启数据类型。
         
         > Oma.setIniConfigs( { "a": 1, "b": true, "c": "hello"}, "/opt/config.ini", { EnableType: true } )
