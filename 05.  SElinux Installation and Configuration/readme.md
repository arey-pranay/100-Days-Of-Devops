# Day 5 — Install and Permanently Disable SELinux

## Original Lab Question

Following a security audit, the xFusionCorp Industries security team has opted to enhance application and server security with SELinux.

Requirements for App Server 1 (`stapp01`):

1. Install the required SELinux packages.
2. Permanently disable SELinux.
3. Do not reboot the server.
4. The final SELinux status after the scheduled reboot must be `disabled`.

## 1. Understand SELinux

**SELinux (Security-Enhanced Linux)** is an additional Linux security mechanism that controls what processes can access.

Traditional Linux permissions control access through:
- Owner
- Group
- Others
- Read, write and execute

SELinux adds another layer of security using Mandatory Access Control (MAC).

For example, even if a web server has normal Linux read permission for a file, SELinux can prevent it from accessing that file based on its security policy.

### SELinux modes

| Mode | Meaning |
|---|---|
| Enforcing | Enforces security policies and blocks violations. |
| Permissive | Does not block violations but logs them. |
| Disabled | SELinux is not enabled. |

The task requires `disabled` after reboot.

## 2. Connect to App Server 1

From the jump host:

```bash
ssh <username>@stapp01
```

Verify the server:

```bash
hostname
whoami
```

- `hostname`: Confirms the target machine.
- `whoami`: Displays the current logged-in user.

## 3. Install SELinux Packages

On a RHEL/CentOS-based server:

```bash
sudo yum install -y selinux-policy selinux-policy-targeted
```

Command breakdown:

- `sudo`: Runs the command with administrative privileges.
- `yum`: Package manager for RHEL-based distributions.
- `install`: Installs packages.
- `-y`: Automatically confirms installation prompts.
- `selinux-policy`: Provides SELinux policy definitions.
- `selinux-policy-targeted`: Provides the targeted SELinux policy.

Why install these packages if SELinux is being disabled?

The task explicitly requires the packages to be installed. Package installation and enabling SELinux are separate operations.

Check installed packages:

```bash
rpm -q selinux-policy selinux-policy-targeted
```

## 4. Permanently Disable SELinux

The main SELinux configuration file is:

```text
/etc/selinux/config
```

Edit it:

```bash
sudo vi /etc/selinux/config
```

Find the existing setting:

```text
SELINUX=enforcing
```

Change it to:

```text
SELINUX=disabled
```

Save and exit:

1. Press `Esc`.
2. Type `:wq`.
3. Press `Enter`.

### Understand the configuration

- `SELINUX`: Configuration directive controlling the SELinux boot mode.
- `enforcing`: Enforces security policies.
- `permissive`: Logs violations without blocking them.
- `disabled`: Disables SELinux at boot.

Why edit this file?

This file stores the persistent SELinux configuration used during system startup. Changing it ensures the requested state after reboot.

## 5. Verify the Configuration

Run:

```bash
grep '^SELINUX=' /etc/selinux/config
```

Expected output:

```text
SELINUX=disabled
```

The command breakdown:

- `grep`: Searches for matching text.
- `^`: Matches the beginning of a line.
- `SELINUX=`: Matches the configuration directive.

The output confirms that the persistent configuration is set correctly.

## 6. Why We Do Not Reboot

There are two different concepts:

**Runtime status:** The SELinux state currently active in memory.

**Persistent configuration:** The state configured for the next system boot.

Editing `/etc/selinux/config` changes the persistent configuration. It does not necessarily change the current runtime state.

The task explicitly says not to reboot because maintenance is already scheduled.

Therefore:

- Do not reboot.
- Do not use `setenforce 0` as a substitute.
- Do not expect the current runtime status to immediately show `disabled`.
- Verify the configuration file instead.

`setenforce 0` changes SELinux from enforcing to permissive. It does not permanently disable SELinux.

## 7. Complete Command Sequence

```bash
ssh <username>@stapp01

hostname
whoami

sudo yum install -y selinux-policy selinux-policy-targeted

sudo vi /etc/selinux/config

# Change SELINUX=enforcing to SELINUX=disabled

grep '^SELINUX=' /etc/selinux/config

rpm -q selinux-policy selinux-policy-targeted
```

## 8. Key Learnings

- SELinux provides an additional security layer beyond traditional Linux permissions.
- SELinux has three main modes: enforcing, permissive and disabled.
- `yum` installs packages on RHEL-based systems.
- `/etc/selinux/config` stores persistent SELinux configuration.
- `SELINUX=disabled` configures SELinux to be disabled at boot.
- Runtime status and persistent configuration are different.
- A reboot is required for the boot-time configuration change to take effect.

## 9. Completion Checklist

- [ ] Connected to `stapp01`.
- [ ] Installed `selinux-policy`.
- [ ] Installed `selinux-policy-targeted`.
- [ ] Changed `SELINUX` to `disabled`.
- [ ] Verified `/etc/selinux/config`.
- [ ] Did not reboot the server.

**Completion condition:** Packages are installed, the configuration file contains `SELINUX=disabled`, and the server has not been rebooted.

*Add the actual terminal transcript after executing the commands. The final runtime status should be confirmed after the scheduled reboot.*
