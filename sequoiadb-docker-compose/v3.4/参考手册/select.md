---
title: select
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1432190960-edition_id-304
---

select 用于从集合中选取数据，结果被存储在一个结果集中。

## 语法

**_select < * | field1_name,field2_name,... | [mathematical_expression](/cn/sequoiadb-cat_id-1510279628-edition_id-304#%E7%AE%97%E6%9C%AF%E8%A1%A8%E8%BE%BE%E5%BC%8F) > from <cs_name.cl_name | statement> [clause]_**

如：

**_select * from <cs_name>.<cl_name>_**

**_select <field1_name,field2_name> from <cs_name>.<cl_name>_**

**_select * from <cs_name>.<cl_name> [where](/cn/sequoiadb-cat_id-1520813394-edition_id-304) <comparison_expression>_**

**_select * from <cs_name>.<cl_name> [where](/cn/sequoiadb-cat_id-1520813394-edition_id-304) <comparison_expression> [order by](/cn/sequoiadb-cat_id-1432190964-edition_id-304) <field1_name>_**

## 参数

参数名 | 参数类型 | 描述 | 是否必填  
---|---|---|---  
field_name/field2_name | string | 字段名 | 否  
mathematical_expression | expression | [算术表达式](/cn/sequoiadb-cat_id-1510279628-edition_id-304#%E7%AE%97%E6%9C%AF%E8%A1%A8%E8%BE%BE%E5%BC%8F) | 否  
cs_name | string | 集合空间名 | 是  
cl_name | string | 集合名 | 是  
statement | statement | 语句 | 否  
clause | expression | 子句 | 否  
  
> **Note:**
> 
>   * 可以选择 where，group by，order by，limit，offset 等子句，对要选择的记录做控制。
> 
>   * 如果查询源不为集合，则本层查询中所有字段均需要引用别名（* 除外），例如：select T.a , T.b from (select * from sample.employee) as T where T.a < 10 。
> 
>   * 子查询必须包含别名。子查询中出现的别名只作用于上一层。
> 
> 

## 返回值

记录集。

## 示例

  * 集合 sample.employee 中原始记录如下：
        
        { age: 10 }
        { age: 10, name: "Tom" }

  * 选择指定的字段名返回，如果某条符合条件的记录没有指定的字段名，那么返回记录中它的值为 null 
        
        > db.exec( "select age,name from sample.employee" )
        { "age": 10, "name": "Tom" }
        { "age": 10, "name": null }
        Return 2 row(s).

  * 返回集合中的所有记录的所有字段名
        
        > db.exec( "select * from sample.employee" )
        { _id: { $oid: "5811ad16751e72e564000016" },  age: 10,  name: "Tom" }
        { _id: { $oid: "5811ad1a751e72e564000017" },  age: 10 }
        Return 2 row(s).
