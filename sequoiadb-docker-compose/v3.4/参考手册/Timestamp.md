---
title: Timestamp
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1440658404-edition_id-304
---

YYYY-MM-DD-HH.mm.ss.ffffff形式的时间戳。范围：1902-01-01 00:00:00.000000至2037-12-31 23:59:59.999999。

数据类型的介绍可参考 [数据类型](/cn/sequoiadb-cat_id-1519612298-edition_id-304)。

## Json格式

  * 语法

_{ "$timestamp": <time> }_

  * 参数描述

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
time | 字符串 | YYYY-MM-DD-HH.mm.ss.ffffff格式的字符串。 | 是  

## 函数格式

  * 语法： 

_Timestamp( [time] )_

_Timestamp( <second>, <microsecond> )_

  * 参数描述

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
time | 字符串 | YYYY-MM-DD-HH.mm.ss.ffffff格式的字符串。 | 否  
second | 数值型 | 使用绝对秒数指定时间戳，秒数。 | 是  
microsecond | 数值型 | 使用绝对秒数指定时间戳，微秒数。 | 是  

## 返回值

无返回值，出错抛异常，并输出错误信息。可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息，通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 错误

错误信息记录在节点诊断日志（diaglog）中，可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

错误码 | 可能的原因 | 解决方法  
---|---|---  
-6 | 参数错误 | 请参考示例。  
  
## 示例

插入时间戳类型的记录
    
    
    > db.sample.employee.insert( { a: {"$timestamp": "2015-06-05-16.10.33.000000" } } )
    > db.sample.employee.insert( { a: Timestamp( "2015-06-05-16.10.33.000000" ) } )
    > db.sample.employee.insert( { a: Timestamp( 1433492413, 0 ) } )
