---
name: sshfs-mount
description: SSHFS 远程挂载管理工具 - 挂载/卸载远程目录、查看状态、守护进程自动重连、生成 CLAUDE.md
version: 1.0.0
---

# SSHFS Mount Manager Skill

此 Skill 提供 SSHFS 远程挂载管理功能，用于管理通过 SSHFS 挂载的远程代码仓库目录。

## 命令列表

| 命令 | 说明 |
|------|------|
| `/sshfs-mount` | 显示帮助菜单 |
| `/sshfs-mount status` | 检查所有远程目录的挂载状态 |
| `/sshfs-mount mount` | 挂载所有配置的远程目录 |
| `/sshfs-mount unmount` | 卸载所有远程目录 |
| `/sshfs-mount init` | 运行初始化向导（首次配置使用） |
| `/sshfs-mount profile list` | 列出所有配置 profile |
| `/sshfs-mount profile switch <name>` | 切换到指定 profile |
| `/sshfs-mount daemon start` | 启动守护进程（自动检测断开并重连） |
| `/sshfs-mount daemon stop` | 停止守护进程 |
| `/sshfs-mount daemon status` | 查看守护进程状态 |
| `/sshfs-mount generate-claude-md` | 为远程挂载目录生成 CLAUDE.md 文件 |
| `/sshfs-mount config-path` | 显示配置文件路径 |

## 使用示例

```bash
# 查看当前挂载状态
/sshfs-mount status

# 挂载所有远程目录
/sshfs-mount mount

# 卸载所有远程目录
/sshfs-mount unmount

# 启动守护进程（后台监控，自动重连）
/sshfs-mount daemon start

# 查看守护进程状态
/sshfs-mount daemon status

# 为远程目录生成 CLAUDE.md（包含 SSH 命令执行规则）
/sshfs-mount generate-claude-md

# 切换配置 profile
/sshfs-mount profile list
/sshfs-mount profile switch work
```

## 配置文件

- **主配置**: `~/.config/sshfs-mounts/config.yaml`
- **Profiles**: `~/.config/sshfs-mounts/profiles/`
- **日志**: `~/.config/sshfs-mounts/daemon.log`

## 配置示例

```yaml
local_root: ~/projects

remotes:
  - name: remote-project1
    host: ubuntu@127.0.0.1
    remote_path: ~/projects
    local_path: remote-project1
    ssh_key: ~/.ssh/id_rsa
    ssh_port: 22
    options:
      reconnect: true
      server_alive_interval: 30

  - name: remote-project2
    host: ubuntu@192.168.0.1
    remote_path: ~/projects
    local_path: remote-project2
    ssh_key: ~/.ssh/id_rsa
    ssh_port: 100
```

## 注意事项

1. **首次使用**需要先运行 `/sshfs-mount init` 进行初始化配置
2. 守护进程默认每 30 秒检查一次挂载状态
3. 生成的 CLAUDE.md 会添加到远程目录根部，提示 Claude Code 在远程主机上执行命令
