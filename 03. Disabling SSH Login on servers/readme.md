# Day 3 — Disable Root SSH Login

## Objective

Disable direct SSH login as `root` on all three app servers: `stapp01`, `stapp02`, and `stapp03`.

The SSH configuration directive required is:

```text
PermitRootLogin no
```

## 1. Connect to the server

```bash
ssh tony@stapp01
```

- `ssh`: Secure Shell, used to connect to another machine securely over a network.
- `tony`: Username on the remote server.
- `stapp01`: Hostname of the target server.

We connect using a normal user account instead of root. Administrative commands can be executed using `sudo`.

## 2. Verify the server and user

```bash
hostname
whoami
```

Output:

```text
stapp01
tony
```

- `hostname`: Displays the machine's hostname. This confirms we're working on the correct server.
- `whoami`: Displays the currently logged-in username.

**Why?** We must avoid accidentally changing the SSH configuration on the jump host or another server.

## 3. Inspect the SSH configuration

```bash
sudo grep -in 'PermitRootLogin' /etc/ssh/sshd_config
```

Output:

```text
40:#PermitRootLogin prohibit-password
90:# the setting of "PermitRootLogin without-password".
131:PermitRootLogin yes
```

Understanding the command:

- `sudo`: Executes the command with administrative privileges. The SSH configuration file requires elevated access.
- `grep`: Searches for matching text in a file.
- `-i`: Ignores uppercase/lowercase differences.
- `-n`: Displays the line number of each match.
- `PermitRootLogin`: SSH setting that controls direct root login.
- `/etc/ssh/sshd_config`: Main SSH server configuration file.

Understanding the output:

- Lines beginning with `#` are comments and are ignored as configuration directives.
- Line 131 is active: `PermitRootLogin yes`.
- This means direct root SSH login is currently permitted.

**Why?** We inspect the existing setting before modifying it so we know what needs to change.

## 4. Modify the configuration

```bash
sudo vi /etc/ssh/sshd_config
```

- `vi`: Terminal-based text editor.
- `sudo`: Required because this is a system configuration file.
- `/etc/ssh/sshd_config`: The file containing SSH server settings.

Find the active directive:

```text
PermitRootLogin yes
```

Change it to:

```text
PermitRootLogin no
```

Save and exit:

1. Press `Esc`.
2. Type `:wq`.
3. Press `Enter`.

**Why?** Setting it to `no` prevents users from connecting directly through SSH as root. Administrators can still use their own accounts and `sudo`.

## 5. Validate the configuration

```bash
sudo sshd -t
```

- `sshd`: SSH server daemon, the background service that handles incoming SSH connections.
- `-t`: Tests the configuration for syntax errors.

There was no output, which means the configuration passed the syntax check.

**Why?** A configuration error could prevent the SSH service from reloading correctly. We validate before applying the change.

## 6. Verify the effective setting

```bash
sudo sshd -T | grep -i '^permitrootlogin'
```

Output:

```text
permitrootlogin no
```

Understanding the command:

- `sshd -T`: Prints the effective SSH server configuration after processing its configuration files.
- `|`: Pipe operator. Sends the output of the command on the left as input to the command on the right.
- `grep`: Filters the output to show only the root-login setting.
- `^`: Matches the beginning of a line.

**Why?** Checking the file alone is insufficient. `sshd -T` confirms that SSH interprets the effective setting as `no`.

## 7. Apply the change to the running service

```bash
sudo systemctl reload sshd
```

- `systemctl`: Utility for managing services through systemd.
- `reload`: Asks a running service to reload its configuration.
- `sshd`: The SSH server service.

**Why?** Editing the configuration file does not automatically make the running SSH service use the new settings. Reloading applies the updated configuration without normally terminating existing SSH sessions.

## 8. Actual Execution Transcript

```console
ssh tony@stapp01
[tony@stapp01 ~]$ hostname
stapp01
[tony@stapp01 ~]$ whoami
tony
sudo grep -in 'PermitRootLogin' /etc/ssh/sshd_config
[sudo] password for tony:
40:#PermitRootLogin prohibit-password
90:# the setting of "PermitRootLogin without-password".
131:PermitRootLogin yes
[tony@stapp01 ~]$ sudo vi /etc/ssh/sshd_config
[tony@stapp01 ~]$ sudo sshd -t
[sudo] password for tony:
[tony@stapp01 ~]$ sudo sshd -T | grep -i '^permitrootlogin'
permitrootlogin no
[tony@stapp01 ~]$ sudo systemctl reload sshd
```

## Key Learnings

- `sshd_config` stores SSH server configuration.
- `PermitRootLogin no` disables direct root SSH login.
- `sshd -t` validates configuration syntax.
- `sshd -T` verifies the effective configuration.
- `systemctl reload` applies changes to the running service.
- `sudo` provides the administrative privileges required for system-level changes.

## Progress
- [x] `stapp01` — Configuration changed, validated, effective setting verified, and SSH service reloaded.
- [ ] `stapp03` — Pending.

**Note:** Only `stapp01` has been verified from the supplied transcript. The lab is complete only after the same change is applied and verified on all three servers.
