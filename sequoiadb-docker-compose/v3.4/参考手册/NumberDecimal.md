---
title: NumberDecimal
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1562588927-edition_id-304
---

高精度数，可以保证精度不丢失。

数据类型的介绍可参考[数据类型](/cn/sequoiadb-cat_id-1519612298-edition_id-304)。

## Json格式

  * **格式1**

语法 _{ "$decimal": <data> }_

参数描述

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
data | 字符串 | 存储的数据内容。 | 是  
  * **格式2**

语法 _{ "$decimal": <data>, "$precision": [<precision>, <scale>] }_

参数描述

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
data | 字符串 | 存储的数据内容。 | 是  
precision | 整数 | 总精度，取值范围为[1, 1000]。 | 是  
scale | 整数 | 小数位精度，取值范围为[0, precision]。 | 是  

## 函数格式

  * 语法

_NumberDecimal( <data>, [ <precision>, <scale> ] )_

参数描述

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
data | 字符串 | 存储的数据内容。 | 是  
precision | 整数 | 总精度，取值范围为[1, 1000]。 | 否  
scale | 整数 | 小数位精度，取值范围为[0, precision]。 | 否  

## 返回值

无返回值，出错抛异常，并输出错误信息。可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息，通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 错误

错误信息记录在节点诊断日志（diaglog）中，可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

错误码 | 可能的原因 | 解决方法  
---|---|---  
-6 | 参数错误 | 请参考示例。  
  
## 示例

插入高精度类型的记录
    
    
    > db.sample.employee.insert( { a: { $decimal: "100.01" } } )
    > db.sample.employee.insert( { a: { $decimal: "100.01", $precision: [ 10, 2 ] } } )
    > db.sample.employee.insert( { a: NumberDecimal( "100.01", [ 10, 2 ] ) } )
