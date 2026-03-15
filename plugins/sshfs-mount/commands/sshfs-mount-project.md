---
command: sshfs-mount-project
description: 挂载指定的单个 SSHFS 远程项目
---

## 功能说明

挂载配置文件中指定的单个远程项目，而不是挂载所有项目。

## 使用方法

在 Claude Code 中直接运行：

```
/sshfs-mount-project <项目名称>
```

或在插件目录中运行：

```bash
cd ~/projects/sshfs-mount/plugins/sshfs-mount
python3 lib/sshfs_mount.py mount <项目名称> -v
```

或使用全局命令（安装后）：

```bash
sshfs-mount mount <项目名称> -v
```

## 参数说明

- `项目名称` - 配置文件中 `remotes` 数组里定义的 `name` 或 `local_path`

## 输出示例

```
Mounting remote-machine1...
✓ Mounted remote-machine1 at /Users/halllo/projects/remote-machine1
```

## 前置条件

1. 确保已运行初始化向导 (`sshfs-mount init`)
2. 确保 SSH key 存在并有正确的权限
3. 确保远程主机 SSH 服务可访问

## 使用示例

### 挂载单个项目

```
/sshfs-mount-project remote-machine1
```

### 查看可用项目

先运行 `/sshfs-status` 查看所有配置的项目：

```
SSHFS Mount Status (local_root: /Users/halllo/projects)

Name                 Status       Mount Point
------------------------------------------------------------
remote-machine1      ✓ Mounted    /Users/halllo/projects/remote-machine1
remote-machine2      ✗ Unmounted  /Users/halllo/projects/remote-machine2
remote-lab           ✗ Unmounted  /Users/halllo/projects/remote-lab
```

然后选择需要挂载的项目。

## 相关命令

- `/sshfs-status` - 检查所有项目的挂载状态
- `/sshfs-mount-all` - 挂载所有远程目录
- `/sshfs-unmount-project` - 卸载指定的单个项目
- `/sshfs-unmount-all` - 卸载所有远程目录
