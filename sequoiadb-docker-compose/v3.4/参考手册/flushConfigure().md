---
title: flushConfigure()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190784-edition_id-304
---

## 名称

flushConfigure - 将节点内存中的配置刷盘至配置文件

## 语法

**db.flushConfigure([options])**

## 类别

Sdb

## 描述

该函数用于将节点内存中的配置刷盘至配置文件。

## 参数

options（ _object，选填_ ）

通过 options 参数可以设定配置过滤类型以及[命令位置参数](/cn/sequoiadb-cat_id-1482314609-edition_id-304)：

  * Type（ _number_ ）：配置过滤类型，默认值为 3

取值如下：

    * 0：所有配置
    * 1：屏敝未修改的隐藏参数
    * 2：屏敝未修改的所有参数
    * 3：屏敝未配置的参数

格式：`Type: 3`

  * Location Elements：命令位置参数项

格式：`GroupName: "db1"`

> **Note:**
> 
>   * 配置过滤类型不正确时默认设置为 3。
>   * 无位置参数时，缺省只对本身节点生效。
> 

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.0 及以上版本

## 示例

刷盘数据库配置
    
    
    > db.flushConfigure({Global: true})
