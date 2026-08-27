---
title: System
category: 参考手册
source: https://doc.sequoiadb.com/cn/sequoiadb-cat_id-1560930213-edition_id-304
---

System 类主要用于获取和操作系统的属性数据，包含的函数如下：

名称 | 描述  
---|---  
[addAHostMap](/cn/sequoiadb-cat_id-1560930214-edition_id-304) | 往 host 文件添加一条主机名到 IP 地址的映射关系  
[addGroup](/cn/sequoiadb-cat_id-1560930347-edition_id-304) | 添加用户组  
[addUser](/cn/sequoiadb-cat_id-1560930348-edition_id-304) | 新增操作系统用户  
[delAHostMap](/cn/sequoiadb-cat_id-1560930349-edition_id-304) | 删除 host 文件中的一条指定主机名的映射关系  
[delGroup](/cn/sequoiadb-cat_id-1560930350-edition_id-304) | 删除系统用户组  
[delUser](/cn/sequoiadb-cat_id-1560930351-edition_id-304) | 删除操作系统用户  
[getAHostMap](/cn/sequoiadb-cat_id-1560931317-edition_id-304) | 获取指定主机名在 host 文件中对应的 IP 地址  
[getCpuInfo](/cn/sequoiadb-cat_id-1560931318-edition_id-304) | 获取 CPU 的信息  
[getCurrentUser](/cn/sequoiadb-cat_id-1560931747-edition_id-304) | 获取当前用户信息  
[getDiskInfo](/cn/sequoiadb-cat_id-1560931319-edition_id-304) | 获取磁盘的信息  
[getEWD](/cn/sequoiadb-cat_id-1560931320-edition_id-304) | 获取当前 sdb shell 所在的目录  
[getHostName](/cn/sequoiadb-cat_id-1560931321-edition_id-304) | 获取主机名  
[getHostsMap](/cn/sequoiadb-cat_id-1560931322-edition_id-304) | 获取 host 文件的 IP 与主机名的映射关系  
[getIpTablesInfo](/cn/sequoiadb-cat_id-1560931323-edition_id-304) | 获取防火墙信息  
[getMemInfo](/cn/sequoiadb-cat_id-1560931324-edition_id-304) | 获取内存信息  
[getNetcardInfo](/cn/sequoiadb-cat_id-1560931325-edition_id-304) | 获取网卡的信息  
[getPID](/cn/sequoiadb-cat_id-1560931326-edition_id-304) | 获取运行 sdb shell 的进程 ID  
[getProcUlimitConfigs](/cn/sequoiadb-cat_id-1560931327-edition_id-304) | 获取进程资源限制值  
[getReleaseInfo](/cn/sequoiadb-cat_id-1560931328-edition_id-304) | 获取操作系统发行版本信息  
[getSystemConfigs](/cn/sequoiadb-cat_id-1560931329-edition_id-304) | 获取系统配置信息  
[getTID](/cn/sequoiadb-cat_id-1560931330-edition_id-304) | 获取运行 sdb shell 的线程 ID  
[getUserEnv](/cn/sequoiadb-cat_id-1560931331-edition_id-304) | 获取当前用户的环境变量  
[isGroupExist](/cn/sequoiadb-cat_id-1560931332-edition_id-304) | 判断指定用户组是否存在  
[isProcExist](/cn/sequoiadb-cat_id-1560931333-edition_id-304) | 判断指定进程是否存在  
[isUserExist](/cn/sequoiadb-cat_id-1560931334-edition_id-304) | 判断指定用户是否存在  
[killProcess](/cn/sequoiadb-cat_id-1560931335-edition_id-304) | 杀死指定进程  
[listAllUsers](/cn/sequoiadb-cat_id-1560931336-edition_id-304) | 列出用户的信息  
[listGroups](/cn/sequoiadb-cat_id-1560931337-edition_id-304) | 列出用户组的信息  
[listLoginUsers](/cn/sequoiadb-cat_id-1560931338-edition_id-304) | 列出登录用户的信息  
[listProcess](/cn/sequoiadb-cat_id-1560931339-edition_id-304) | 列出进程的信息  
[ping](/cn/sequoiadb-cat_id-1560931340-edition_id-304) | 判断到达指定主机的网络是否连通  
[runService](/cn/sequoiadb-cat_id-1560931341-edition_id-304) | 运行 service 命令  
[setProcUlimitConfigs](/cn/sequoiadb-cat_id-1560931342-edition_id-304) | 修改进程资源限制值  
[setUserConfigs](/cn/sequoiadb-cat_id-1560931343-edition_id-304) | 修改操作系统用户的配置  
[snapshotCpuInfo](/cn/sequoiadb-cat_id-1560931344-edition_id-304) | 获取 CPU 的基本信息  
[snapshotDiskInfo](/cn/sequoiadb-cat_id-1560931345-edition_id-304) | 获取磁盘的信息  
[snapshotMemInfo](/cn/sequoiadb-cat_id-1560931346-edition_id-304) | 获取内存的基本信息  
[snapshotNetcardInfo](/cn/sequoiadb-cat_id-1560931347-edition_id-304) | 获取网卡的详细信息  
[sniffPort](/cn/sequoiadb-cat_id-1560931348-edition_id-304) | 判断指定端口是否可用  
[type](/cn/sequoiadb-cat_id-1560931349-edition_id-304) | 获取操作系统类别
