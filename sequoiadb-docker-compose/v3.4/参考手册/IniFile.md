---
title: IniFile
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1568720801-edition_id-304
---

IniFile 类主要用于操作 INI 文件对象，包含的函数如下：

名称 | 描述  
---|---  
[IniFile()](/cn/sequoiadb-cat_id-1568720802-edition_id-304) | 新建一个 INI 文件对象  
[addComment()](/cn/sequoiadb-cat_id-1568720803-edition_id-304) | 为指定的 item 追加注释  
[addSectionComment()](/cn/sequoiadb-cat_id-1568720804-edition_id-304) | 为指定的 section 追加注释  
[addLastComment()](/cn/sequoiadb-cat_id-1568720805-edition_id-304) | 在尾部追加注释  
[setComment()](/cn/sequoiadb-cat_id-1568720806-edition_id-304) | 设置指定 item 的注释  
[setSectionComment()](/cn/sequoiadb-cat_id-1568720807-edition_id-304) | 设置指定 section 的注释  
[setLastComment()](/cn/sequoiadb-cat_id-1568720808-edition_id-304) | 设置尾部的注释  
[delComment()](/cn/sequoiadb-cat_id-1568720809-edition_id-304) | 删除指定 item 的注释  
[delSectionComment()](/cn/sequoiadb-cat_id-1568720810-edition_id-304) | 删除指定 section 的注释  
[delLastComment()](/cn/sequoiadb-cat_id-1568720811-edition_id-304) | 删除尾部注释  
[enableItem()](/cn/sequoiadb-cat_id-1568720812-edition_id-304) | 取消注释指定的 item  
[disableItem()](/cn/sequoiadb-cat_id-1568720813-edition_id-304) | 注释指定的 item  
[disableAllItem()](/cn/sequoiadb-cat_id-1568720814-edition_id-304) | 注释全部 item  
[getComment()](/cn/sequoiadb-cat_id-1568720815-edition_id-304) | 获取指定 item 的注释  
[getSectionComment()](/cn/sequoiadb-cat_id-1568720816-edition_id-304) | 获取指定 section 的注释  
[getLastComment()](/cn/sequoiadb-cat_id-1568720817-edition_id-304) | 获取尾部注释  
[getValue()](/cn/sequoiadb-cat_id-1568720818-edition_id-304) | 获取指定 item 的值  
[setValue()](/cn/sequoiadb-cat_id-1568720819-edition_id-304) | 设置指定 item 的值  
[toObj()](/cn/sequoiadb-cat_id-1568720820-edition_id-304) | 转换成对象  
[toString()](/cn/sequoiadb-cat_id-1568720821-edition_id-304) | 转换成文本  
[save()](/cn/sequoiadb-cat_id-1568720822-edition_id-304) | 保存 INI 配置
