# Linux User Management: Create a User with a Non-Interactive Shell

## Lab question

To accommodate the backup agent tool's specifications, the system admin
team at `xFusionCorp Industries` requires the creation of a user with a
non-interactive shell.

**Task:** Create a user named `kareem` with a non-interactive shell on
**App Server 3** (hostname `stapp03`).

**Instructions:** Find the infrastructure details in KodeKloud, connect
to the app server from the jump host using SSH and the app-server
username, then use `sudo` to create the user.

> **Important transcript discrepancy:** The terminal session supplied
> for this README connects to `stapp02`, not `stapp03`, and
> creates/checks `ammar`, not `kareem`. The transcript therefore
> documents a similar user-management exercise, but it does **not**
> demonstrate completion of the exact question above. Confirm the
> intended server and username before marking the original task
> complete.

------------------------------------------------------------------------

## Goal

Create a Linux account whose configured login shell is `nologin`.

A non-interactive login shell is useful for service accounts, such as
accounts used by backup agents. The account can own files and run
permitted processes, while normal interactive login through that shell
is rejected.

`nologin` is not a complete security boundary. Permissions, service
configuration, SSH settings, and other access controls still matter.

## Prerequisites and concepts

### 1. Jump host and application server

A **server** is a computer that provides a service to other computers. A
**remote server** is administered over a network rather than by sitting
at its keyboard.

A **jump host** (also called a bastion host) is an entry point used to
reach machines on a private network.

The intended connection path is:

``` text
Administrator / KodeKloud terminal
              |
              | already connected
              v
          Jump host
              |
              | SSH
              v
     App Server 3 (stapp03)
```

Linux accounts are local to a machine unless the organization uses
centralized identity management. Creating a user on the jump host does
not create that user on an application server.

### 2. SSH

SSH means **Secure Shell**. It is a protocol for securely accessing a
remote machine and running commands there.

General syntax:

``` bash
ssh <username>@<hostname>
```

For example:

``` bash
ssh steve@stapp02
```

-   `ssh` starts the SSH client.
-   `steve` is the account name on the destination machine.
-   `@` separates the account name from the host.
-   `stapp02` is the destination hostname.

SSH commonly uses TCP port `22`. The SSH client connects to the
server-side SSH daemon (`sshd`), negotiates an encrypted connection,
verifies the server host key, and authenticates the user (for example,
with a password or SSH key). After successful authentication, the server
starts the user's configured session.

### 3. Confirm which machine and account you are using

Run:

``` bash
hostname
whoami
```

-   `hostname` prints the machine's hostname.
-   `whoami` prints the effective username of the current session.

Always confirm the destination before making administrative changes.

### 4. Linux users and account files

Linux is a multi-user operating system. Each account has an identity and
configuration, including a username, UID, primary group, home directory,
and login shell.

Important files:

  -----------------------------------------------------------------------
  Path                                Purpose
  ----------------------------------- -----------------------------------
  `/etc/passwd`                       Account records: username, UID,
                                      GID, comment, home directory, and
                                      login shell

  `/etc/shadow`                       Password hashes and password-aging
                                      information; normally restricted

  `/etc/group`                        Group records and membership
                                      information

  `/etc/shells`                       Lists shells recognized by the
                                      system as valid login shells

  `/etc/skel`                         Default files copied into a new
                                      home directory when one is created

  `/home/<user>`                      Typical home directory for a
                                      regular user

  `/etc/ssh/sshd_config`              SSH server configuration
  -----------------------------------------------------------------------

An `/etc/passwd` record has seven colon-separated fields:

``` text
username:password-placeholder:UID:GID:comment:home-directory:login-shell
```

Example:

``` text
steve:x:1000:1000::/home/steve:/bin/bash
```

The `x` is not the user's password. Password hashes are normally stored
in `/etc/shadow`.

### 5. Shells and `nologin`

A **shell** is a command interpreter. Bash (`/bin/bash`), for example,
lets a user enter commands, run programs, use pipes and redirection, and
write shell scripts.

A user's configured login shell is the final field in their
`/etc/passwd` record.

`nologin` is a program used as a login shell to reject normal
interactive login sessions. Its path varies by distribution; on the
supplied server it was:

``` text
/usr/sbin/nologin
```

Check the path on the target machine rather than assuming it:

``` bash
command -v nologin
```

### 6. `sudo` and `useradd`

-   `root` is the system's administrative account, normally UID `0`.
-   `sudo` allows an authorized user to run a command with elevated
    privileges.
-   `useradd` creates a user account.
-   `-s` selects the user's login shell.

General syntax:

``` bash
sudo useradd -s <shell-path> <username>
```

For the original task, after confirming the shell path on `stapp03`, the
command would be:

``` bash
sudo useradd -s /usr/sbin/nologin kareem
```

Use the actual path returned by `command -v nologin` if it differs.

## Procedure for the stated lab question

1.  Open KodeKloud's **Details of all Users and Servers** and find the
    SSH username for App Server 3.

2.  From the jump host, connect using that username and the short
    hostname:

    ``` bash
    ssh <app-server-username>@stapp03
    ```

3.  Confirm the destination:

    ``` bash
    hostname
    whoami
    ```

    The hostname must be `stapp03`.

4.  Find the `nologin` path:

    ``` bash
    command -v nologin
    ```

5.  Create the requested user, using the path discovered above:

    ``` bash
    sudo useradd -s /usr/sbin/nologin kareem
    ```

6.  Verify the account and its configured shell:

    ``` bash
    id kareem
    getent passwd kareem
    ```

    The final field in the `getent passwd` output should be the
    `nologin` path.

7.  Exit the remote session:

    ``` bash
    exit
    ```

## Supplied terminal transcript

The following is the terminal output supplied for this README. It is
preserved as provided, with the server and account names called out
above.

``` console
thor@jump-host ~$ ssh steve@stapp02
steve@stapp02's password:
[steve@stapp02 ~]$ hostname
stapp02
[steve@stapp02 ~]$ whoami
steve
[steve@stapp02 ~]$ command -v nologin
/usr/sbin/nologin
[steve@stapp02 ~]$ sudo useradd -s /usr/sbin/nologin ammar

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve:
[steve@stapp02 ~]$ sudo useradd -s /usr/sbin/nologin ammar
useradd: user 'ammar' already exists
[steve@stapp02 ~]$ id ammar
uid=1001(ammar) gid=1001(ammar) groups=1001(ammar)
[steve@stapp02 ~]$ exit
logout
Connection to stapp02 closed.
thor@jump-host ~$
```

## Understanding the transcript

### What the commands did

  -------------------------------------------------------------------------------
  Command                                     Meaning
  ------------------------------------------- -----------------------------------
  `ssh steve@stapp02`                         Connect to `stapp02` as user
                                              `steve`

  `hostname`                                  Confirm the remote machine's
                                              hostname

  `whoami`                                    Confirm the current account

  `command -v nologin`                        Find the `nologin` executable in
                                              the command search path

  `sudo useradd -s /usr/sbin/nologin ammar`   Attempt to create `ammar` with
                                              `nologin` as its login shell

  `id ammar`                                  Display the existing account's UID,
                                              GID, and groups

  `exit`                                      Close the SSH session and return to
                                              the jump host
  -------------------------------------------------------------------------------

### Why did `useradd` report that the user already exists?

The transcript shows the `useradd` command was run twice. The second
attempt returned:

``` text
useradd: user 'ammar' already exists
```

This means an account named `ammar` already existed when the second
command ran. The subsequent `id ammar` confirms that the account exists
and shows its numeric IDs and group membership.

However, `id ammar` does **not** verify the configured login shell. To
verify the shell, run:

``` bash
getent passwd ammar
```

Then inspect the last field. It should be `/usr/sbin/nologin` for the
intended configuration.

The transcript does not include this check, so the shell configuration
is not independently verified by the supplied output.

### What the `sudo` lecture means

The multi-line message is a standard sudo warning shown on some systems.
It reminds administrators that elevated privileges carry responsibility.
It is not an error.

The password prompt asks for the password of the invoking user
(`steve`), not necessarily the root password.

## Verification and troubleshooting

Useful checks:

``` bash
# Confirm the machine
hostname

# Confirm the current user
whoami

# Find nologin
command -v nologin

# Check that the account exists and inspect IDs/groups
id kareem

# Inspect the complete account record, including its shell
getent passwd kareem

# Inspect the nologin executable
ls -l /usr/sbin/nologin
```

Common issues:

  -------------------------------------------------------------------------------
  Symptom                             What to check
  ----------------------------------- -------------------------------------------
  SSH says                            Check the short hostname and
  `Could not resolve hostname`        network/infrastructure details

  SSH says `Permission denied`        Check the app-server username,
                                      password/key, and SSH access

  `useradd: user already exists`      Inspect the existing account with `id` and
                                      `getent passwd`; do not create it again

  `nologin` path differs              Use the path returned by
                                      `command -v nologin`

  `sudo` is denied                    Confirm the account is authorized to use
                                      sudo or follow the lab's provided access
                                      instructions

  User exists but shell is wrong      Inspect with `getent passwd`; an
                                      administrator can correct it with
                                      `sudo usermod -s <shell-path> <username>`
  -------------------------------------------------------------------------------

## Key learnings

-   A server is a computer providing services; it can be administered
    remotely.
-   SSH securely connects a client to a remote machine.
-   A jump host is an entry point to other machines on a network.
-   Always verify the hostname before changing a server.
-   Linux account information is represented in files such as
    `/etc/passwd`, `/etc/shadow`, and `/etc/group`.
-   A UID identifies a user to the operating system; a GID identifies a
    group.
-   A shell is the command interpreter associated with a user's login
    session.
-   `nologin` rejects normal interactive login through that shell and is
    commonly used for service accounts.
-   `sudo` runs an authorized command with elevated privileges.
-   `useradd -s <shell> <username>` creates a user with a specified
    login shell.
-   Verify the result with `id` and `getent passwd`, rather than relying
    only on the command's output.

## Final status

**The supplied transcript does not prove completion of the stated
KodeKloud question.**

It shows an attempt involving `ammar` on `stapp02`. The stated question
requires `kareem` on `stapp03`.

To complete the original question, connect to `stapp03`, create `kareem`
with the discovered `nologin` path, and verify the shell using:

``` bash
getent passwd kareem
```
