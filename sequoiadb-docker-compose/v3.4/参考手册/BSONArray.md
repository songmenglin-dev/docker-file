---
title: BSONArray
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1562588920-edition_id-304
---

BSON 数组。

数据类型的介绍可参考[数组](/cn/sequoiadb-cat_id-1519612298-edition_id-304#%E6%95%B0%E7%BB%84%E7%B1%BB%E5%9E%8B)。

## 语法

**BSONArray.size()**

**BSONArray.more()**

**BSONArray.next()**

**BSONArray.pos()**

**BSONArray.toArray()**

**BSONArray.index()**

**BSONArray.toString()**

## 方法

### size()

获取 BSONArray 的大小。

### more()

判断 BSONArray 下一条记录是否为空，返回 false 表示下一条记录为空。

### next()

获取 BSONArray 的下一条记录。

### pos()

获取 BSONArray 当前下标的记录。

### toArray()

把 BSONArray 转化为普通数组。

### index()

获取 BSONArray 当前的下标。

### toString()

把 BSONArray 以字符串的形式输出。

## 错误

如果出错则抛异常，并输出错误信息，可以通过[getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304)获取错误信息或通过[getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304)获取错误码。关于错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

常见错误可参考[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。

## 示例

  * 获取 BSONArray ( 关于 oma 的详解介绍可参考 [oma](/cn/sequoiadb-cat_id-1495022521-edition_id-304) )。
        
        > var oma = new Oma( "localhost", 11790 )
        > var bsonArray = oma.listNodes()

  * 获取 BSONArray 的大小。
        
        > bsonArray.size() 
        3

  * 判断 BSONArray 下一条记录是否为空。
        
        > bsonArray.more() 
        true

  * 获取 BSONArray 的下一条记录。
        
        > bsonArray.next() 
        {
          "svcname": "30010",
          "type": "sequoiadb",
          "role": "catalog",
          "pid": 8305,
          "groupid": 1,
          "nodeid": 2,
          "primary": 0,
          "isalone": 0,
          "groupname": "SYSCatalogGroup",
          "starttime": "2019-07-11-16.20.19",
          "dbpath": "/opt/trunk/database/30010/"
        }   

  * 获取 BSONArray 当前下标的记录。
        
        > bsonArray.pos() 
        {
         "svcname": "50000",
         "type": "sequoiadb",
         "role": "coord",
         "pid": 8308,
         "groupid": 2,
         "nodeid": 4,
         "primary": 1,
         "isalone": 0,
         "groupname": "SYSCoord",
         "starttime": "2019-07-11-16.20.19",
         "dbpath": "/opt/trunk/database/50000/"
        }

  * 把 BSONArray 转为普通数组。
        
        > var array = bsonArray.toArray() 
        > array instanceof Array
        true

  * 获取 BSONArray 当前的下标。
        
        > bsonArray.index() 
        1

  * 把 BSONArray 以字符串的形式输出。
        
        > bsonArray.toString() 
        {
          "svcname": "50000",
          "type": "sequoiadb",
          "role": "coord",
          "pid": 8308,
          "groupid": 2,
          "nodeid": 4,
          "primary": 1,
          "isalone": 0,
          "groupname": "SYSCoord",
          "starttime": "2019-07-11-16.20.19",
          "dbpath": "/opt/trunk/database/50000/"
        }
        {
          "svcname": "20000",
          "type": "sequoiadb",
          "role": "data",
          "pid": 8311,
          "groupid": 1000,
          "nodeid": 1000,
          "primary": 1,
          "isalone": 0,
          "groupname": "db1",
          "starttime": "2019-07-11-16.20.19",
          "dbpath": "/opt/trunk/database/20000/"
        }
