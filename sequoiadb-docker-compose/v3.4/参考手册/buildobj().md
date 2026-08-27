---
title: buildobj()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190981-edition_id-304
---

聚集函数

将记录中多个字段合并为一个对象。

## 语法

**_buildobj(field_name1,[field_name2,...])_**

## 参数

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
field_name1 | string | 集合全名 | 是  
field_name2 | string | 查询结果集 | 否  
  
## 返回值

包含多个字段的对象。

## 示例

  * 集合 sample.employee 中记录如下：
        
        {a:1,b:1,c:1}
        {a:2,b:2,c:2}
        {a:3,b:3,c:3}

  * 将集合 sample.employee 中记录的 b, c 字段合并到对象 d 中 
        
        > db.exec("select a, buildobj(b, c) as d from sample.employee")
        { "a": 1, "d": { "b": 1, "c": 1 } }
        { "a": 2, "d": { "b": 2, "c": 2 } }
        { "a": 3, "d": { "b": 3, "c": 3 } }
        Return 3 row(s).
