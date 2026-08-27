---
title: analyze()
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1496923440-edition_id-304
---

## 名称

analyze - 收集统计信息

## 语法

**db.analyze([options])**

## 类别

Sdb

## 描述

该函数用于分析集合和索引的数据，并收集[统计信息](/cn/sequoiadb-cat_id-1496923311-edition_id-304)。

## 参数

options ( _object，选填_ )

通过参数 options 可以指定分析模式、集合空间和命令位置参数：

  * Mode ( _number_ )：分析模式，默认值为 1

取值如下：

    * 1：进行抽样分析，生成统计信息
    * 2：进行全量数据分析，生成统计信息
    * 3：生成默认字段值的统计信息
    * 4：加载统计信息到缓存中
    * 5：清除缓存中的统计信息

Mode 取 1~3 时，必须在主数据节点上执行；取 3 时，必须指定参数 Collection，默认生成该集合及所有索引的统计信息，若同时指定参数 Index，则生成该集合及指定索引的统计信息。

格式：`Mode: 1`

  * CollectionSpace ( _string_ )：集合空间名称，默认为空

该参数不能与参数 Collection 同时使用。

格式：`CollectionSpace: "sample"`

  * Collection ( _string_ )：集合名称，默认为空

该参数不能与参数 CollecitonSpace 同时使用，且必须指定集合全名。

格式：`Collection: "sample.employee"`

  * Index ( _string_ )：索引名称，默认为空

指定该参数时，需要同时指定参数 Collection。

格式：`Index: "index"`

  * SampleNum ( _number_ )：抽样的数据个数，范围为 100~10000，默认值为 200

该参数不能与参数 SamplePercent 同时使用。

格式：`SampleNum: 1000`

  * SamplePercent ( _number_ )：抽样的比例，范围为 0.0~100.0

    * 该参数不能与参数 SampleNum 同时使用，缺省则不使用该参数，而选取参数 SampleNum 的默认值 200。
    * 抽样的数据个数为集合数据个数和比例的乘积，范围为 100~10000（小于 100 调整为 100，大于 10000 调整为 10000）。

格式：`SamplePercent: 50`

  * Location Elements

命令位置参数项，可参考[命令位置参数](/cn/sequoiadb-cat_id-1482314609-edition_id-304)

格式：`GroupName: "db1"`

## 返回值

函数执行成功时，无返回值。

函数执行失败时，将抛异常并输出错误信息。

## 错误

`analyze()` 函数常见异常如下：

错误码 | 错误类型 | 可能发生的原因 | 解决办法  
---|---|---|---  
-34 | SDB_DMS_CS_NOTEXIST | 集合空间不存在 | 检查集合空间是否存在  
-23 | SDB_DMS_NOTEXIST | 指定的集合不存在 | 检查集合是否存在  
-47 | SDB_IXM_NOTEXIST | 指定的索引不存在 | 重试操作，若故障未修复，则需要联系售后工程师进行修复  
-6 | SDB_INVALIDARG | 指定的参数可能存在冲突，可参考 options 的说明 | 查看对应节点的诊断日志，找到该参数错误的详细描述，并加以修正重试  
  
当异常抛出时，可以通过 [getLastErrMsg()](/cn/sequoiadb-cat_id-1477902870-edition_id-304) 获取错误信息或通过 [getLastError()](/cn/sequoiadb-cat_id-1477902869-edition_id-304) 获取[错误码](/cn/sequoiadb-cat_id-1432190985-edition_id-304)。更多错误处理可以参考[常见错误处理指南](/cn/sequoiadb-cat_id-1478742401-edition_id-304)。

## 版本

v2.9 及以上版本

## 示例

  * 对所有集合空间进行统计信息分析和收集
        
        > db.analyze()

  * 对指定集合空间 sample 进行统计信息分析和收集
        
        > db.analyze({CollectionSpace: "sample"})

  * 对指定数据组 group1 进行统计信息分析和收集
        
        > db.analyze({GroupName: "group1"})

  * 对指定集合 sample.employee 进行统计信息收集，并指定参数 SampleNum
        
        > db.analyze({Collection: "sample.employee", SampleNum: 1000})

  * 对指定集合 sample.employee 的索引 index 进行统计信息收集
        
        > db.analyze({Collection: "sample.employee", Index: "index"})

  * 对指定集合 sample.employee 生成清空统计信息缓存
        
        > db.analyze({Collection: "sample.employee", Mode: 5})
