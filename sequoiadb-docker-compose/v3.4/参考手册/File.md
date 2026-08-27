---
title: File
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1552033393-edition_id-304
---

File 类主要用于操作文件，包含的函数如下：

名称 | 描述  
---|---  
[File()](/cn/sequoiadb-cat_id-1552034509-edition_id-304) | 打开文件或者创建新文件  
[chgrp()](/cn/sequoiadb-cat_id-1552034276-edition_id-304) | 设置文件的用户组  
[chmod()](/cn/sequoiadb-cat_id-1552034306-edition_id-304) | 设置文件权限  
[chown()](/cn/sequoiadb-cat_id-1552034314-edition_id-304) | 设置文件的所有者  
[close()](/cn/sequoiadb-cat_id-1552034536-edition_id-304) | 关闭文件  
[copy()](/cn/sequoiadb-cat_id-1552034465-edition_id-304) | 复制文件  
[exist()](/cn/sequoiadb-cat_id-1552034485-edition_id-304) | 判断文件是否存在  
[find()](/cn/sequoiadb-cat_id-1552034961-edition_id-304) | 查找文件  
[getSize()](/cn/sequoiadb-cat_id-1552714654-edition_id-304) | 获取文件的大小  
[getUmask()](/cn/sequoiadb-cat_id-1552034969-edition_id-304) | 获取新建文件权限的掩码  
[isDir()](/cn/sequoiadb-cat_id-1552034988-edition_id-304) | 判断指定文件是否为目录  
[isEmptyDir()](/cn/sequoiadb-cat_id-1552034996-edition_id-304) | 判断指定目录是否为空目录  
[isFile()](/cn/sequoiadb-cat_id-1552035003-edition_id-304) | 判断指定文件是否为普通文件  
[list()](/cn/sequoiadb-cat_id-1552035012-edition_id-304) | 列出当前目录的文件  
[md5()](/cn/sequoiadb-cat_id-1552035021-edition_id-304) | 获取文件的 md5 值  
[mkdir()](/cn/sequoiadb-cat_id-1552035037-edition_id-304) | 创建目录  
[move()](/cn/sequoiadb-cat_id-1552035045-edition_id-304) | 移动文件  
[read()](/cn/sequoiadb-cat_id-1552035053-edition_id-304) | 读取文本文件  
[readContent()](/cn/sequoiadb-cat_id-1552035061-edition_id-304) | 读取二进制文件内容并存入 FileContent 对象  
[readLine()](/cn/sequoiadb-cat_id-1552035070-edition_id-304) | 读取文件的一行数据  
[remove()](/cn/sequoiadb-cat_id-1552035077-edition_id-304) | 删除文件或者目录  
[scp()](/cn/sequoiadb-cat_id-1552035084-edition_id-304) | 远程拷贝文件  
[seek()](/cn/sequoiadb-cat_id-1552035091-edition_id-304) | 移动文件游标  
[setUmask()](/cn/sequoiadb-cat_id-1552035099-edition_id-304) | 设置新建文件的权限掩码  
[stat()](/cn/sequoiadb-cat_id-1552035108-edition_id-304) | 显示文件的状态信息  
[write()](/cn/sequoiadb-cat_id-1552035115-edition_id-304) | 往文本文件中写内容  
[writeContent()](/cn/sequoiadb-cat_id-1552035121-edition_id-304) | 将 fileContent 对象中的二进制内容写入文件中  
[truncate()](/cn/sequoiadb-cat_id-1572867150-edition_id-304) | 将文件截断到给定的长度
