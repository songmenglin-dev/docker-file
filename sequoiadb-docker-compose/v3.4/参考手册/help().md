---
title: help()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1529976601-edition_id-304
---

## 名称

help - 显示帮助信息

## 语法

**help()**

**help( <method>)**

## 类别

Global

## 描述

在全局范围内显示帮助信息：

  * help() - 显示全局的帮助信息。

  * help(<method>) - 显示具体方法的详细文档信息。

另外，也可以在类和对象范围查看帮助信息：

  * <class>.help() - 显示该类或对象包含的所有方法。

  * <class>.help(<method>) - 显示类或对象具体方法的详细文档信息。

## 参数

  * class（ _object_ ， _必填_ ）

javascript 类或者对象

  * method（ _string_ ， _必填_ ）

类或者对象的方法名

## 返回值

帮助信息

## 错误

无

## 版本

v1.0 及以上版本

## 示例

  * 显示全局帮助信息
        
        > help()

  * 显示类包含的的所有方法
        
        > Oma.help()
            --Constructor methods for class "Oma":
            var oma = new Oma([hostname],[svcname])
                                  - Class for cluster management.
            --Static methods for class "Oma":
            Oma.addAOmaSvcName(<hostname>,<svcname>,[isReplace],[confFile])
                                  - Specify the service name of sdbcm in target
                                    host.
            Oma.delAOmaSvcName(hostname,[confFile])
                                  - Delete the service name of sdbcm from its
                                    configuration file in target host.
            Oma.getAOmaSvcName(hostname,[confFile])
                                  - Get the service name of sdbcm in target host.
            ...

  * 显示对象包含的所有方法
        
        > var oma = new Oma()
        > oma.help()
            --Instance methods for class "Oma":
            close()              - Close the Oma object.
            createCoord(<svcname>,<dbpath>,[config])
                                 - Create a coord node in target host of sdbcm.
            createData(<svcname>,<dbpath>,[config])
                                 - Create a standalone node in target host of
                                   sdbcm.
            ...

  * 查看具体方法的详细帮助文档
        
        > help("createCS")
        
        createCS(1)                       Version 2.8                      createCS(1)
        
        NAME
            createCS - Create a collection space in current database.
        
        SYNOPSIS
            db.createCS(<name>,[options])
        
        CATEGORY
            Sequoiadb
        
        DESCRIPTION
            Create a collection space in a database instance.
        
            name (string)
                    Collection space name. Collection space name should be
                    unique to each other in a database instance.
        ...

  * 查询具体类或者对象具体方法的详细帮助文档
        
        > var db = new Sdb()
        > db.sample.help("createCL") // 或者 SdbCS.help("createCL")
        
        createCL(1)                       Version 2.8                      createCL(1)
        
        NAME
            createCL - create a new collection.
        
        SYNOPSIS
            db.collectionspace.createCL(<name>,[option])
        
        CATEGORY
            Collection Space
        
        DESCRIPTION
            Create a collection in a specified collection space.  Collection is a
            logical object which stores records.  Each record should belong to one
            and only one collection.
        
        PARAMETERS
            * name ( String , Required )
        
                The name of the collection, should be unique to each other in a
                collection space.
        
        ...
