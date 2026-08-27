---
title: SdbDate
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1440658405-edition_id-304
---

YYYY-MM-DD形式的日期。范围：0000-01-01至9999-12-31。

数据类型的介绍可参考 [数据类型](/cn/sequoiadb-cat_id-1519612298-edition_id-304)。

## Json格式

  * 语法

_{ "$date": <date> }_

  * 参数描述

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
date | 字符串 | YYYY-MM-DD格式的字符串。 | 是  

## 函数格式

  * 语法： 

_SdbDate( [data] )_

  * 参数描述

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
date | 字符串 | YYYY-MM-DD格式的字符串。  
为空时，生成当天的日期。 | 否  

## 返回值

无返回值，出错抛异常，并输出错误信息。可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息，通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 错误

错误信息记录在节点诊断日志（diaglog）中，可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

错误码 | 可能的原因 | 解决方法  
---|---|---  
-6 | 参数错误 | 请参考示例。  
  
## 示例

插入日期类型的记录
    
    
    > db.sample.employee.insert( { date: { $date: "2015-03-13" } } )
    > db.sample.employee.insert( { date: SdbDate( "2015-03-13" ) } )
    > db.sample.employee.insert( { date: SdbDate() } )
