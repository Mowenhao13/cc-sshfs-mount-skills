#!/usr/bin/env python3
"""
SSHFS Mount Manager - CLAUDE.md Auto-generator
This script generates CLAUDE.md files for remote-mounted directories
"""

import os
import sys
import subprocess
from pathlib import Path

# Import from main module
sys.path.insert(0, str(Path(__file__).parent))
from sshfs_mount import load_config, expand_path, check_mount_status


def get_ssh_port_from_config(host: str) -> str:
    """Get SSH port from SSH config file for a given host.

    Args:
        host: SSH host string (user@host or host:port)

    Returns:
        Port number as string, or empty string if not found or using default port 22
    """
    # First check if port is specified in host string (user@host:port format)
    if ':' in host and '@' in host:
        # Format: user@host:port
        port_part = host.split(':')[-1]
        if port_part.isdigit() and port_part != '22':
            return port_part
    elif ':' in host and '@' not in host:
        # Format: host:port (no user)
        port_part = host.split(':')[-1]
        if port_part.isdigit() and port_part != '22':
            return port_part

    # Check SSH config file for port
    ssh_config_path = Path.home() / ".ssh" / "config"
    if not ssh_config_path.exists():
        return ""

    current_host = None
    target_port = ""

    try:
        with open(ssh_config_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue

                if line.startswith('Host '):
                    parts = line.split()
                    if len(parts) >= 2:
                        alias = parts[1]
                        # Check if this host matches
                        if alias == host or host.split('@')[-1].split(':')[0] == alias:
                            current_host = alias
                        else:
                            current_host = None
                    continue

                if current_host and line.startswith('Port '):
                    try:
                        port = line.split(None, 1)[1].strip()
                        if port != '22':
                            target_port = port
                    except (ValueError, IndexError):
                        pass
    except Exception:
        pass

    return target_port


def generate_claude_md(mount_point: Path, ssh_host: str, remote_name: str, ssh_key: str = "~/.ssh/id_rsa", force: bool = False) -> bool:
    """Generate CLAUDE.md file for a remote mount.

    Args:
        mount_point: The mount point directory
        ssh_host: SSH host string
        remote_name: Remote name
        ssh_key: SSH key path
        force: If True, overwrite existing file. If False, skip if exists.

    Returns:
        True if file was generated/updated, False if skipped
    """
    claude_md = mount_point / "CLAUDE.md"

    # Check if file already exists
    if claude_md.exists() and not force:
        print(f"  ⚠ Skipping {remote_name}: CLAUDE.md already exists (use --force to overwrite)")
        return False

    # Expand SSH key path for display
    ssh_key_expanded = os.path.expanduser(ssh_key)

    # Get SSH port from config
    ssh_port = get_ssh_port_from_config(ssh_host)
    port_note = ""
    if ssh_port:
        port_note = f"\n### SSH 端口配置\n\n此主机使用非默认 SSH 端口 **{ssh_port}**。SSH 连接时需要指定端口：\n\n```bash\nssh -i {ssh_key_expanded} -p {ssh_port} user@host\n```\n\n或在 `~/.ssh/config` 中配置：\n\n```\nHost {ssh_host.split('@')[-1].split(':')[0]}\n    Port {ssh_port}\n```"

    content = f'''# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 重要：远程仓库命令执行规则

**本目录是通过 SSHFS 挂载的远程主机目录，所有命令必须在远程主机上执行！**

当 Claude Code 需要运行命令时：
1. **不要直接在本地终端运行命令**
2. **必须先 SSH 登录到远程主机**，然后在远程主机上执行
3. 或者使用 `ssh -i {ssh_key_expanded} user@host "command"` 的方式远程执行

### 远程主机连接信息

| 挂载点 | SSH 主机 | 说明 |
|--------|----------|------|
| `{mount_point}` | `ssh -i {ssh_key_expanded} {ssh_host}` | {remote_name} |

### 命令执行示例

**错误做法**（在本地直接运行）：
```bash
python train.py  # 会在本地 macOS 运行，错误！
```

**正确做法**（SSH 到远程后运行）：
```bash
# 方式 1：先登录远程主机
ssh -i {ssh_key_expanded} {ssh_host}
cd ~/projects/my-repo
python train.py

# 方式 2：直接远程执行
ssh -i {ssh_key_expanded} {ssh_host} "cd ~/projects/my-repo && python train.py"
```

---
{port_note}
'''

    with open(claude_md, 'w') as f:
        f.write(content)

    if claude_md.exists():
        print(f"  ✓ Overwritten {remote_name} (CLAUDE.md already existed)")
    else:
        print(f"  ✓ Generated {remote_name}")
    return True


def generate_all(force: bool = False) -> None:
    """Generate CLAUDE.md for all mounted remotes.

    Args:
        force: If True, overwrite existing files. If False, skip existing files.
    """
    config = load_config()
    local_root = expand_path(config.get("local_root", "~/projects"))
    remotes = config.get("remotes", [])

    if not remotes:
        print("No remotes configured.")
        return

    if force:
        print(f"Generating CLAUDE.md files for {len(remotes)} remote(s)... (forcing overwrite)\n")
    else:
        print(f"Generating CLAUDE.md files for {len(remotes)} remote(s)...\n")
        print("  Tip: Use --force to overwrite existing CLAUDE.md files\n")

    for remote in remotes:
        name = remote.get("name", "unknown")
        local_path = remote.get("local_path", name)
        mount_point = local_root / local_path
        host = remote.get("host", "")
        ssh_key = remote.get("ssh_key", "~/.ssh/id_rsa")

        # Check if mounted
        if not check_mount_status(mount_point):
            print(f"  Skipping {name} (not mounted)")
            continue

        # Generate CLAUDE.md
        generate_claude_md(mount_point, host, name, ssh_key, force)


def check_current_directory() -> None:
    """Check if current directory is an SSHFS mount."""
    cwd = Path.cwd()

    try:
        result = subprocess.run(
            ["mount"],
            capture_output=True,
            text=True
        )

        is_sshfs = False
        for line in result.stdout.split('\n'):
            if str(cwd) in line and 'sshfs' in line:
                is_sshfs = True
                break

        if is_sshfs:
            print(f"Current directory ({cwd}) is an SSHFS mount.")

            claude_md = cwd / "CLAUDE.md"
            if not claude_md.exists():
                print("CLAUDE.md not found.")
                print("\nRun this to generate:")
                print("  sshfs-mount generate-claude-md")
            else:
                print("CLAUDE.md already exists.")
        else:
            print("Current directory is not an SSHFS mount.")

    except Exception as e:
        print(f"Error checking mount status: {e}")


def main():
    if len(sys.argv) < 2:
        print("Usage: generate-claude-md {check|generate|generate-all} [--force]")
        print()
        print("Commands:")
        print("  check         Check if current directory is SSHFS mount")
        print("  generate      Generate CLAUDE.md for specific mount")
        print("  generate-all  Generate CLAUDE.md for all mounted remotes")
        print()
        print("Options:")
        print("  --force       Overwrite existing CLAUDE.md files (default: skip existing)")
        sys.exit(1)

    command = sys.argv[1]
    force = "--force" in sys.argv

    if command == "check":
        check_current_directory()

    elif command == "generate":
        if len(sys.argv) < 5:
            print("Usage: generate-claude-md generate <mount_point> <ssh_host> <remote_name>")
            sys.exit(1)

        mount_point = expand_path(sys.argv[2])
        ssh_host = sys.argv[3]
        remote_name = sys.argv[4]
        ssh_key = sys.argv[5] if len(sys.argv) > 5 else "~/.ssh/id_rsa"

        generate_claude_md(mount_point, ssh_host, remote_name, ssh_key, force)

    elif command == "generate-all":
        generate_all(force)

    else:
        print(f"Unknown command: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()
