# SSHFS Mount Manager

技能命令：`/sshfs-mount` - 管理 SSHFS 远程挂载

## 子命令

- `/sshfs-mount` - 显示主菜单
- `/sshfs-mount status` - 检查挂载状态
- `/sshfs-mount mount` - 挂载所有远程目录
- `/sshfs-mount unmount` - 卸载所有远程目录
- `/sshfs-mount init` - 重新运行初始化向导（自动读取 ~/.ssh/config）
- `/sshfs-mount profile` - Profile 管理
- `/sshfs-mount daemon` - 守护进程管理
- `/sshfs-mount generate-claude-md` - 为远程挂载目录生成 CLAUDE.md

## 使用示例

```bash
# 查看挂载状态
/sshfs-mount status

# 挂载所有远程目录
/sshfs-mount mount

# 卸载所有远程目录
/sshfs-mount unmount

# 查看守护进程状态
/sshfs-mount daemon status

# 启动守护进程（自动重连）
/sshfs-mount daemon start

# 为所有远程挂载目录生成 CLAUDE.md
/sshfs-mount generate-claude-md
```

## 快速挂载脚本

skill 目录中包含一个快速挂载脚本 `sshfs`，可以直接使用：

```bash
# 基本用法
./sshfs <user@host:remote_path> <local_path> [options]

# 示例：挂载 remote-matrix
./sshfs halllo-max@172.18.198.243:~/projects ~/projects/remote-matrix \
  -o IdentityFile=~/.ssh/id_rsa_mac \
  -o reconnect \
  -o ServerAliveInterval=30

# 示例：挂载 remote-lab（带端口）
./sshfs ubuntu@172.18.166.57:~/projects ~/projects/remote-lab \
  -p 55900 \
  -i ~/.ssh/id_rsa_mac
```

## 配置文件位置

- 主配置：`~/.config/sshfs-mounts/config.yaml`
- Profiles: `~/.config/sshfs-mounts/profiles/`
- 日志：`~/.config/sshfs-mounts/daemon.log`
