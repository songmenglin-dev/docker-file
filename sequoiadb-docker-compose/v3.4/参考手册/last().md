---
title: last()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190978-edition_id-304
---

聚集函数

选择范围内最后一条数据。

## 语法

**_last(field_name)_**

## 参数

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
field_name | string | 字段名 | 是  
  
## 返回值

范围内指定字段的最后一条数据。

## 示例

  * 集合 sample.employee 中原始记录如下：
        
        {a:0, b:2}
        {a:1, b:2}
        {a:2, b:3}
        {a:3, b:3}

  * 选择以 b 分组的各个范围中最后一条数据 
        
        > db.exec( "select last(a) as a, b from sample.employee group by b" )
        { "a": 1, "b": 2 }
        { "a": 3, "b": 3 }
        Return 2 row(s).
