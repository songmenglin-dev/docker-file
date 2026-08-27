---
title: MinKey
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1440658408-edition_id-304
---

最小值，所有数据类型中的最小值。

数据类型的介绍可参考 [数据类型](/cn/sequoiadb-cat_id-1519612298-edition_id-304)。

## Json格式

  * 语法

_{ "$minKey": 1 }_

  * 参数描述

无

## 函数格式

  * 语法： 

_MinKey()_

  * 参数描述

无

## 返回值

无返回值，出错抛异常，并输出错误信息，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息 或 通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304) 。

## 错误

错误信息记录在节点诊断日志（diaglog）中，可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 示例

插入最小值类型的记录
    
    
    > db.sample.employee.insert( { a: { "$minKey": 1 } } )
    > db.sample.employee.insert( { a: MinKey() } )
