---
title: setCurrentValue()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1606119779-edition_id-304
---

## 名称

setCurrentValue - 设置序列的当前值

## 语法

**sequence.setCurrentValue( <value>)**

## 类别

SdbSequence

## 描述

该函数用于设置序列的当前值，从而调整序列的进度。对于递增序列，设置的当前值只能增大，不能减小；对于递减序列，则相反。该特性可以避免序列生成重复值，如需反向设置，可以使用 [restart()](/cn/sequoiadb-cat_id-1606120788-edition_id-304) 函数。

## 参数

value（ _number_ ， _必填_ ）

指定的当前值

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`setCurrentValue()`函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-361 | SDB_SEQUENCE_VALUE_USED | 指定当前值已经被使用 | 如要反向设置，可以使用 [restart()](/cn/sequoiadb-cat_id-1606120788-edition_id-304) 函数。  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取错误码。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v3.4.2 及以上版本

## 示例

  * 将递增序列值设置为更小的值
        
        > sequence.getCurrentValue()
        1000
        > sequence.setCurrentValue( 500 )

输出错误信息如下：
        
        (shell):1 uncaught exception: -361
        Sequence value has been used

  * 将递增序列值设置为更大的值
        
        > sequence.getCurrentValue()
        1000
        > sequence.setCurrentValue( 2000 )

设置后获取的当前序列值如下：
        
        > sequence.getCurrentValue()
        2000
