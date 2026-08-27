---
title: updateNodeConfigs()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1580718046-edition_id-304
---

## 名称

updateNodeConfigs - 更新节点配置信息

## 语法

**oma.updateNodeConfigs( <svcname>, <config>)**

## 类别

Oma

## 描述

该函数用于更新指定节点的配置信息，更新后需重启节点或使用 [reloadConf()](/cn/sequoiadb-cat_id-1483064748-edition_id-304) 重载配置文件，使配置生效。

## 参数

  * svcname ( _number/string，必填_ )

节点端口号

  * config ( _object，必填_ )

节点配置信息，如更新日志大小、是否打开事务等，具体可参考[配置项参数](/cn/sequoiadb-cat_id-1632902617-edition_id-304)。

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`updateNodeConfigs()` 函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-6 | SDB_INVALIDARG | 非法输入参数 | 检查端口号和配置信息是否正确  
-259 | SDB_OUT_OF_BOUND | 未输入节点端口号或配置信息 | 输入节点端口号以及配置信息  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.2 及以上版本

## 示例

将节点 11810 的配置项参数 diaglevel 更新为 3
    
    
    > var oma = new Oma("localhost", 11790)
    > oma.updateNodeConfigs(11810, {diaglevel: 3})
