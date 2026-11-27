# Day 4 — Make a Bash Script Executable

## Original Lab Question

> In a bid to automate backup processes, the `xFusionCorp Industries` sysadmin team has developed a new bash script named `xfusioncorp.sh`. While the script has been distributed to all necessary servers, it lacks executable permissions on `App Server 3` within the Stratos Datacenter.
>
> Your task is to grant executable permissions to the `/tmp/xfusioncorp.sh` script on `App Server 3`. Additionally, ensure that all users have the capability to execute it.

## 1. Understand the Concepts

Linux file permissions have three categories:

| Category | Symbol | Meaning |
|---|---|---|
| Owner | `u` | User who owns the file |
| Group | `g` | Users belonging to the file's group |
| Others | `o` | Everyone else |

Three basic permissions:

- `r` = Read (4): View file contents.
- `w` = Write (2): Modify file contents.
- `x` = Execute (1): Run the file.

A shell script needs **read and execute permissions**. The interpreter must be able to read its contents while executing it.

## 2. Connect and Inspect the File

```bash
ssh banner@stapp03
hostname
whoami
ls -l /tmp/xfusioncorp.sh
```

- `ssh`: Connects securely to a remote server.
- `hostname`: Confirms the target server.
- `whoami`: Displays the current user.
- `ls -l`: Displays file details, including permissions and ownership.

Expected initial permissions:

```text
---------- 1 root root 40 Nov 27 15:38 /tmp/xfusioncorp.sh
```

`----------` means nobody has read, write, or execute permission.

The file belongs to `root`, while we are logged in as `banner`.

## 3. Change Permissions

An ordinary user cannot change permissions on a file owned by another user.

Therefore, use `sudo`:

```bash
sudo chmod 755 /tmp/xfusioncorp.sh
```

Understanding the command:

- `sudo`: Runs the command with administrative privileges.
- `chmod`: Changes file permissions.
- `755`: Sets permissions for owner, group, and others.
- `/tmp/xfusioncorp.sh`: Target file.

### Understanding 755

| Number | Calculation | Permission |
|---|---|---|
| 7 | 4 + 2 + 1 | Read, write, execute |
| 5 | 4 + 1 | Read, execute |
| 5 | 4 + 1 | Read, execute |

Result:

```text
-rwxr-xr-x
```

This allows everyone to read and execute the script, while only the owner can modify it.

**Alternative:**

```bash
sudo chmod 777 /tmp/xfusioncorp.sh
```

`777` grants read, write, and execute permissions to everyone. It satisfies the execution requirement but unnecessarily allows everyone to modify the script. Prefer `755`.

## 4. Verify the Permissions

```bash
ls -l /tmp/xfusioncorp.sh
```

Expected with `755`:

```text
-rwxr-xr-x 1 root root 40 Nov 27 15:49 /tmp/xfusioncorp.sh
```

You can also inspect numeric permissions:

```bash
stat -c '%a %n' /tmp/xfusioncorp.sh
```

Expected:

```text
755 /tmp/xfusioncorp.sh
```

## 5. Actual Execution Transcript

The following is the actual transcript from the supplied session. Note that this session connected to `stapp01`, not the required `stapp03`.

```console
thor@jump-host ~$ ssh tony@stapp01
The authenticity of host 'stapp01 (10.244.13.28)' can't be established.
ED25519 key fingerprint is SHA256:b0JAiKM2aJHOdJKe+IhGj0VV2xLurw9VlNHgs6VJ3bg.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'stapp01' (ED25519) to the list of known hosts.
tony@stapp01's password:
[tony@stapp01 ~]$ ^C
[tony@stapp01 ~]$ ls -l /tmp/xfusioncorp.sh
---------- 1 root root 40 Nov 27 15:49 /tmp/xfusioncorp.sh
[tony@stapp01 ~]$ chmod 777 /tmp/xfusioncorp.sh
chmod: changing permissions of '/tmp/xfusioncorp.sh': Operation not permitted
[tony@stapp01 ~]$ ls -l /tmp/xfusioncorp.sh
---------- 1 root root 40 Nov 27 15:49 /tmp/xfusioncorp.sh
[tony@stapp01 ~]$ sudo chmod 777 /tmp/xfusioncorp.sh

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for tony:
Sorry, try again.
[sudo] password for tony:
Sorry, try again.
[sudo] password for tony:
[tony@stapp01 ~]$ sudo chmod 777 /tmp/xfusioncorp.sh
[tony@stapp01 ~]$ ls -l /tmp/xfusioncorp.sh
-rwxrwxrwx 1 root root 40 Nov 27 15:49 /tmp/xfusioncorp.sh
[tony@stapp01 ~]$ exit
logout
Connection to stapp01 closed.
```

## 6. Important Learnings

- `chmod a+x` adds execute permission to everyone but does not add read permission.
- `chmod 755` grants read and execute to everyone, with write permission reserved for the owner.
- `chmod 777` grants full permissions to everyone and is generally less secure.
- `sudo` is necessary when the current user does not own the file and lacks permission to change it.
- Always verify the result using `ls -l`.

## 7. Completion Status

- [x] Understand file permissions.
- [x] Understand why `chmod` failed without `sudo`.
- [x] Successfully changed permissions on `stapp01`.
- [ ] Apply the required permissions on `stapp03`.
- [ ] Verify the required server's final permissions.

**Important:** The original lab requires App Server 3 (`stapp03`). The supplied successful transcript is from App Server 1 (`stapp01`), so it does not prove completion of the original task.

Correct command on the required server:

```bash
ssh banner@stapp03
sudo chmod 755 /tmp/xfusioncorp.sh
ls -l /tmp/xfusioncorp.sh
```
