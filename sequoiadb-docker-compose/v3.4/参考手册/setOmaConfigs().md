---
title: setOmaConfigs()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1580718042-edition_id-304
---

## 名称

setOmaConfigs - 把 sdbcm 的配置信息写入到其配置文件。

## 语法

**oma.setOmaConfigs( <config>,[confFile])**

## 类别

Oma

## 描述

把 sdbcm 的配置信息写入到其配置文件。

## 参数

  * `config` ( _Object_ ， _必填_ )

[sdbcm](/cn/sequoiadb-cat_id-1432190631-edition_id-304) 的配置信息。

  * `confFile` ( _String_ ， _选填_ )

sdbcm 的配置文件，若不指定该参数，默认使用[getOmaConfigFile()](/cn/sequoiadb-cat_id-1580718034-edition_id-304) 定的配置文件。

## 返回值

成功：无。

失败：抛出异常。

## 错误

`setOmaConfigs()`函数常见异常如下：

错误码 | 错误类型 | 描述 | 解决方法  
---|---|---|---  
-4 | SDB_FNE | 文件不存在 | 确认输入的 sdbcm 配置文件是否存在。  
  
当异常抛出时，可以通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)，或通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息。 可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)了解更多内容。

## 版本

v2.0及以上版本。

## 示例

  1. 将 sdbcm 的日志级别由ERROR级别(3)改为DEBUG级别(5)，并使该改动动态生效。
         
         > var ret = Oma.getOmaConfigs()
         > var obj = ret.toObj()
         > println(obj["DiagLevel"])
         3
         > obj["DiagLevel"] = 5
         > Oma.setOmaConfigs(obj)
         > var oma = new Oma()
         > oma.reloadConfigs()
