---
command: sshfs-status
description: 显示 SSHFS 挂载状态 - 检查所有远程目录的挂载情况
---

## 功能说明

检查并显示所有配置的 SSHFS 远程目录的挂载状态。

## 执行方式

在插件目录中运行：

```bash
cd ~/projects/sshfs-mount/plugins/sshfs-mount
python3 lib/sshfs_mount.py status
```

或使用全局命令（安装后）：

```bash
sshfs-mount status
```

## 输出示例

```
SSHFS Mount Status (local_root: /Users/halllo/projects)

Name                 Status       Mount Point
------------------------------------------------------------
remote-machine1      ✓ Mounted    /Users/halllo/projects/remote-machine1
remote-machine2      ✗ Unmounted  /Users/halllo/projects/remote-machine2
```

## 相关命令

- `/sshfs-mount` - 挂载所有远程目录
- `/sshfs-unmount` - 卸载所有远程目录
- `/sshfs-daemon status` - 查看守护进程状态
