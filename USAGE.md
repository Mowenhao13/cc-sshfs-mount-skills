# SSHFS Mount Manager - 使用指南

## 快速开始

### 1. 安装

```bash
# 运行安装脚本
./install.sh

# 如果 ~/.local/bin 不在 PATH 中，添加它：
export PATH="$HOME/.local/bin:$PATH"
# 永久添加（添加到 ~/.zshrc）：
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 2. 初始化配置

运行初始化向导，它会自动读取你的 `~/.ssh/config` 文件：

```bash
sshfs-mount init
```

**初始化向导功能：**
- 自动检测并显示现有 SSH 配置
- 支持使用 SSH alias 或完整的 user@host 格式
- 自动填充 SSH key 路径和端口号

### 3. 挂载远程目录

```bash
# 挂载所有配置的远程目录
sshfs-mount mount

# 查看挂载状态
sshfs-mount status
```

### 4. 启动守护进程（可选）

守护进程会每 30 秒检查一次挂载状态，自动重连断开的目录：

```bash
# 启动守护进程
sshfs-daemon start

# 查看守护进程状态
sshfs-daemon status

# 停止守护进程
sshfs-daemon stop
```

### 5. 生成 CLAUDE.md（可选）

为所有远程挂载目录自动生成 CLAUDE.md 文件：

```bash
sshfs-mount generate-claude-md
```

### 6. 快速挂载脚本

skill 目录中包含一个快速挂载脚本 `sshfs`，可以直接使用命令行挂载：

```bash
# 基本用法
~/.claude/skills/sshfs-mount/sshfs <user@host:remote_path> <local_path> [options]

# 示例：挂载 remote-machine1
~/.claude/skills/sshfs-mount/sshfs ubuntu@172.18.198.243:~/projects ~/projects/remote-machine1 \
  -o IdentityFile=~/.ssh/id_rsa \
  -o reconnect \
  -o ServerAliveInterval=30

# 示例：挂载 remote-machine2（带端口）
~/.claude/skills/sshfs-mount/sshfs ubuntu@172.18.166.57:~/projects ~/projects/remote-machine2 \
  -p 55900 \
  -i ~/.ssh/id_rsa
```

**支持的选项：**
- `-i <keyfile>`: SSH key 文件路径（默认：~/.ssh/id_rsa）
- `-p <port>`: SSH 端口（默认：22）
- `-o <option>`: 额外的 sshfs 选项

---

## 命令行参考

### 主命令

| 命令 | 说明 |
|------|------|
| `sshfs-mount status` | 显示所有远程目录的挂载状态 |
| `sshfs-mount mount` | 挂载所有远程目录 |
| `sshfs-mount unmount` | 卸载所有远程目录 |
| `sshfs-mount init` | 运行初始化向导 |
| `sshfs-mount profile list` | 列出所有 profile |
| `sshfs-mount profile switch <name>` | 切换到指定 profile |
| `sshfs-mount generate-claude-md` | 生成 CLAUDE.md 文件 |
| `sshfs-mount config-path` | 显示配置文件路径 |

### 守护进程命令

| 命令 | 说明 |
|------|------|
| `sshfs-daemon start` | 启动守护进程 |
| `sshfs-daemon start <interval>` | 指定检查间隔（秒） |
| `sshfs-daemon stop` | 停止守护进程 |
| `sshfs-daemon status` | 查看守护进程状态 |

---

## 配置文件格式

### 基本配置 (~/.config/sshfs-mounts/config.yaml)

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
    local_path: remote-lab
    ssh_key: ~/.ssh/id_rsa
    ssh_port: 55900
```

### Profile 配置 (~/.config/sshfs-mounts/profiles/work.yaml)

```yaml
name: work
description: 工作开发环境

local_root: ~/work-projects

remotes:
  - name: remote-prod
    host: user@prod-server.example.com
    remote_path: ~/projects
    local_path: remote-prod
```

---

## 从现有 SSH 配置导入

如果你的 `~/.ssh/config` 已经有主机配置，初始化向导会自动读取：

**示例 SSH config:**
```
Host ubuntu
  HostName 172.18.166.57
  Port 55900
  User ubuntu
  IdentityFile ~/.ssh/id_rsa

Host 172.18.198.243
  HostName 172.18.198.243
  User halllo-max
  IdentityFile ~/.ssh/id_rsa
```

**初始化向导会：**
1. 显示所有检测到的 SSH 主机
2. 允许你直接输入 Host alias（如 `ubuntu`）
3. 自动填充对应的 HostName、Port、IdentityFile

---

## Claude Code Skills 集成

安装后，在 Claude Code 中使用 `/sshfs-mount` 命令：

```
/sshfs-mount           # 显示帮助
/sshfs-mount status    # 检查挂载状态
/sshfs-mount mount     # 挂载所有
/sshfs-mount unmount   # 卸载所有
/sshfs-mount init      # 重新初始化
/sshfs-mount generate-claude-md  # 生成 CLAUDE.md
/sshfs-mount daemon start        # 启动守护进程
```

---

## 故障排除

### 挂载失败

```bash
# 检查 sshfs 是否安装
which sshfs

# 检查 SSH key 权限
chmod 600 ~/.ssh/id_rsa

# 测试 SSH 连接
ssh user@host
```

### 查看日志

```bash
# 守护进程日志
tail -f ~/.config/sshfs-mounts/daemon.log

# 手动运行查看错误
sshfs-mount mount -v
```

### 配置文件问题

```bash
# 查看配置文件位置
sshfs-mount config-path

# 手动编辑配置
code ~/.config/sshfs-mounts/config.yaml
```

---

## 卸载

```bash
# 卸载所有挂载
sshfs-mount unmount

# 停止守护进程
sshfs-daemon stop

# 删除安装文件
rm -rf ~/.claude/skills/sshfs-mount
rm -rf ~/.config/sshfs-mounts
rm ~/.local/bin/sshfs-mount ~/.local/bin/sshfs-daemon
```
