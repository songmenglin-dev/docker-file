---
title: STOREPROCEDURES集合
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1519625797-edition_id-304
---

SYSPROCEDURES.STOREPROCEDURES 集合中包含了所有的存储过程函数，每一个函数保存为一个文档。

每个文档包含以下字段：

字段名 | 类型 | 描述  
---|---|---  
name | string | 函数名  
func | string | 函数体  
funcType | number | 函数类型   
0：代表 JavaScript 函数   
其他类型暂无  
  
## 示例

一个简单的存储过程函数如下：
    
    
    {
      "_id" : { "$oid" : "5257b115925c31dd16ec4e4a" },
      "name" : "fun",
      "func" : "function fun(num) {
          if (num == 1) {
              return 1;
          } else {
              return fun(num - 1) * num;
          }
      }",
      "funcType" : 0
    }
