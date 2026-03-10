# SSHFS Mount Manager
你是否还在为服务器装不上 Claude Code 而烦恼?

一个通用的 SSHFS 远程挂载管理工具，专为 Claude Code Skills 设计。

## 项目创作动机
作者在服务器上装了cc 但由于cc连接不上我的coding plan 于是只能通过告知本地的cc通过ssh来连接服务器才可运行 但在同时连接两台远端linux设备时 总是会出现需要反复声明ssh服务器来执行命令的操作 每次都要告知cc仓库所在的文件路径 而且本地由于没有挂载远端仓库 导致每次查看文件 都需要ssh 增加麻烦 当仓库一多时 如果仓库不写CLAUDE.md 就会经常出错 于是这款插件便诞生了 

## 功能特性

- 🔧 **通用配置** - 支持任意数量的远程主机，每个主机独立配置
- 📋 **Profile 管理** - 支持多套配置（工作/个人等场景）
- 🔄 **守护进程** - 自动检测断开并重连
- 🤖 **Claude Code 集成** - 通过 Skills 提供便捷的挂载管理
- 📝 **CLAUDE.md 自动生成** - 为远程目录自动生成使用说明

## 项目结构

```
sshfs-mount/
├── sshfs_mount.py        # 主程序（配置管理、挂载/卸载、初始化向导）
├── sshfs_daemon.py       # 守护进程（自动重连）
├── generate_claude_md.py # CLAUDE.md 自动生成器
├── install.sh            # 安装脚本
├── create-package.sh     # 创建分发包脚本
├── README.md             # 本文档
└── skill/
    ├── sshfs-mount.md    # Skill 说明文档
    └── sshfs-mount.sh    # Skill 入口脚本
```

## 快速开始

### 安装

```bash
# 克隆或下载项目
cd sshfs-mount

# 运行安装脚本
./install.sh
```

### 首次使用

```bash
# 运行初始化向导
sshfs-mount init

# 或从 Claude Code 中
/sshfs-mount init
```

### 基本命令

```bash
# 查看挂载状态
sshfs-mount status

# 挂载所有远程目录
sshfs-mount mount

# 卸载所有远程目录
sshfs-mount unmount

# 启动守护进程（自动重连）
sshfs-daemon start

# 查看守护进程状态
sshfs-daemon status
```

## 配置文件

### 配置文件位置

- **主配置**: `~/.config/sshfs-mounts/config.yaml`
- **Profiles**: `~/.config/sshfs-mounts/profiles/`
- **日志**: `~/.config/sshfs-mounts/daemon.log`

### 配置文件格式

```yaml
local_root: ~/projects

remotes:
  - name: remote-machine1
    host: ubuntu@172.18.198.243
    remote_path: ~/projects 
    local_path: remote-machine1
    ssh_key: ~/.ssh/id_rsa
    ssh_port: 22
    options:
      reconnect: true
      server_alive_interval: 30

  - name: remote-machine2
    host: ubuntu@172.18.166.57
    remote_path: ~/projects
    local_path: remote-machine2
    ssh_key: ~/.ssh/id_rsa
    ssh_port: 55900
```

### Profile 配置示例

```yaml
# ~/.config/sshfs-mounts/profiles/work.yaml
name: work
description: 工作开发环境

local_root: ~/work-projects

remotes:
  - name: remote-prod
    host: user@prod-server.example.com
    remote_path: ~/projects
    local_path: remote-prod
```

## Claude Code Skills

安装后，在 Claude Code 中使用 `/sshfs-mount` 命令:

```
/sshfs-mount          # 显示菜单
/sshfs-mount status   # 检查挂载状态
/sshfs-mount mount    # 挂载所有
/sshfs-mount unmount  # 卸载所有
/sshfs-mount init     # 重新运行初始化向导
/sshfs-mount profile  # Profile 管理
/sshfs-mount daemon   # 守护进程管理
```

## Profile 管理

```bash
# 列出所有 profile
sshfs-mount profile list

# 切换到 work profile
sshfs-mount profile switch work
```

## 守护进程

守护进程每 30 秒检查一次挂载状态，自动重新连接断开的远程目录。

```bash
# 启动守护进程
sshfs-daemon start

# 指定检查间隔（秒）
sshfs-daemon start 60

# 停止守护进程
sshfs-daemon stop

# 查看状态
sshfs-daemon status
```

## 依赖

- Python 3.6+
- sshfs
- PyYAML

### 安装依赖
> [!NOTE]
> macos 上的sshfs安装可能有些复杂 需要去查询教程

```bash
# macOS
brew install sshfs 
pip3 install pyyaml

# Ubuntu/Debian
sudo apt-get install sshfs python3-yaml

# Arch Linux
sudo pacman -S sshfs python-yaml
```


## 故障排除

### 挂载失败

检查 SSH key 是否存在并有正确的权限：
```bash
ls -la ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
```

### 连接断开

检查网络连接和 SSH 服务：
```bash
ssh user@host  # 测试 SSH 连接
```

### 查看日志

```bash
# 查看守护进程日志
tail -f ~/.config/sshfs-mounts/daemon.log
```

