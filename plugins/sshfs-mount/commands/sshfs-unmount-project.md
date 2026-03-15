---
command: sshfs-unmount-project
description: 卸载指定的单个 SSHFS 远程项目
---

## 功能说明

卸载已挂载的单个远程项目，而不是卸载所有项目。

## 使用方法

在 Claude Code 中直接运行：

```
/sshfs-unmount-project <项目名称>
```

或在插件目录中运行：

```bash
cd ~/projects/sshfs-mount/plugins/sshfs-mount
python3 lib/sshfs_mount.py unmount <项目名称> -v
```

或使用全局命令（安装后）：

```bash
sshfs-mount unmount <项目名称> -v
```

## 参数说明

- `项目名称` - 配置文件中 `remotes` 数组里定义的 `name` 或 `local_path`

## 输出示例

```
✓ Unmounted remote-machine1
```

## 使用示例

### 卸载单个项目

```
/sshfs-unmount-project remote-machine1
```

### 查看已挂载的项目

先运行 `/sshfs-status` 查看所有项目的挂载状态：

```
SSHFS Mount Status (local_root: /Users/halllo/projects)

Name                 Status       Mount Point
------------------------------------------------------------
remote-machine1      ✓ Mounted    /Users/halllo/projects/remote-machine1
remote-machine2      ✗ Unmounted  /Users/halllo/projects/remote-machine2
```

然后选择需要卸载的项目。

## 注意事项

- 如果指定的项目未挂载，会显示 "is not mounted" 提示
- 卸载失败时会尝试强制卸载 (`umount -f`)
- 只影响指定的项目，其他已挂载的项目不受影响

## 相关命令

- `/sshfs-status` - 检查所有项目的挂载状态
- `/sshfs-mount-project` - 挂载指定的单个项目
- `/sshfs-mount-all` - 挂载所有远程目录
- `/sshfs-unmount-all` - 卸载所有远程目录
