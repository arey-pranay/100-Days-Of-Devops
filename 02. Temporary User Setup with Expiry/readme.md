# Linux User Management: Create a User with an Expiry Date

## Lab question

As part of the temporary assignment to the `Nautilus` project, a
developer named `ravi` requires access for a limited duration.

**Task:** Create a user named `ravi` on **App Server 2** in Stratos
Datacenter. Set the expiry date to `2027-04-15`, ensuring the user is
created in lowercase as per standard protocol.

## Goal

Create the Linux account `ravi` on App Server 2 (`stapp02`) and
configure its account expiration date as April 15, 2027.

Account expiration makes an account invalid for normal authentication
after the configured expiration point. It does not automatically delete
the user or their files.

## Prerequisites and concepts

### 1. Jump host and remote server

A **jump host** (also called a bastion host) is an entry point used to
access machines on a private network.

``` text
KodeKloud terminal
       |
       v
   Jump host
       |
       | SSH
       v
App Server 2 (stapp02)
```

Linux accounts are local to a machine unless centralized identity
management is configured. Creating a user on the jump host does not
create that user on `stapp02`.

### 2. SSH

SSH means **Secure Shell**. It is a protocol for securely connecting to
a remote machine and running commands there.

General syntax:

``` bash
ssh <username>@<hostname>
```

For this lab:

``` bash
ssh <app-server-2-username>@stapp02
```

SSH commonly uses TCP port `22`. The SSH client connects to the
server-side daemon (`sshd`), establishes an encrypted connection,
verifies the server's host key, and authenticates the user using an
accepted method such as a password or SSH key.

After connecting, verify the destination:

``` bash
hostname
whoami
```

`hostname` should report `stapp02`. `whoami` prints the current
effective username. Always confirm the destination before making
system-wide changes.

### 3. Linux account files

Linux is a multi-user operating system. Each account has an identity and
configuration, including a username, UID, primary group, home directory,
and login shell.

  -----------------------------------------------------------------------
  Path                                Purpose
  ----------------------------------- -----------------------------------
  `/etc/passwd`                       General account records: username,
                                      UID, GID, home directory, login
                                      shell, and other fields

  `/etc/shadow`                       Password hashes, password-aging
                                      data, and account expiration
                                      information

  `/etc/group`                        Group records and membership
                                      information

  `/etc/skel`                         Default files copied into a new
                                      home directory when one is created

  `/home/<user>`                      Typical home directory for a
                                      regular user
  -----------------------------------------------------------------------

An `/etc/passwd` record has seven colon-separated fields:

``` text
username:password-placeholder:UID:GID:comment:home-directory:login-shell
```

The `x` often shown in its password field is a placeholder. Password
hashes are normally stored separately in `/etc/shadow`.

### 4. Account expiration vs password expiration

These are different settings:

  -----------------------------------------------------------------------
  Setting                             Meaning
  ----------------------------------- -----------------------------------
  Account expiration                  The account becomes invalid after a
                                      specified date

  Password expiration                 The password reaches its maximum
                                      age and may need to be changed

  User deletion                       The account is removed from the
                                      system
  -----------------------------------------------------------------------

The eighth field of `/etc/shadow` represents the account expiration
date. It is stored internally as the number of days since January 1,
1970 (the Unix epoch).

Use account-management commands to set and inspect this value; do not
manually edit `/etc/shadow`.

### 5. `sudo` and `useradd`

-   `root` is the system's administrative account, normally UID `0`.
-   `sudo` allows an authorized user to execute a command with elevated
    privileges.
-   `useradd` creates a user account.
-   `-e` specifies the account expiration date.

General syntax:

``` bash
sudo useradd -e YYYY-MM-DD username
```

For this task:

``` bash
sudo useradd -e 2027-04-15 ravi
```

The username is lowercase, as required.

### 6. The `chage` command

`chage` manages password-aging and account-expiration information.

``` bash
# List account-aging information
sudo chage -l ravi

# Set account expiration
sudo chage -E 2027-04-15 ravi

# Remove account expiration
sudo chage -E -1 ravi

# Set maximum password age to 90 days
sudo chage -M 90 ravi
```

Important distinction:

-   `-E` controls **account expiration**.
-   `-M` controls **maximum password age**.

For this lab, `useradd -e` is sufficient because the expiry date is
configured during account creation.

## Procedure

1.  Open KodeKloud's **Details of all Users and Servers** and find the
    SSH username for App Server 2.

2.  From the jump host, connect to `stapp02`:

    ``` bash
    ssh <app-server-2-username>@stapp02
    ```

3.  Confirm the machine:

    ``` bash
    hostname
    whoami
    ```

    The hostname should be `stapp02`.

4.  Create `ravi` with the requested expiry date:

    ``` bash
    sudo useradd -e 2027-04-15 ravi
    ```

5.  Verify that the account exists:

    ``` bash
    id ravi
    ```

6.  Verify the expiration setting:

    ``` bash
    sudo chage -l ravi
    ```

    Look for:

    ``` text
    Account expires : Apr 15, 2027
    ```

    Date formatting may vary by system locale.

7.  You can also inspect the account record:

    ``` bash
    getent passwd ravi
    ```

    This confirms that the account record exists, but does **not** show
    the expiration date. Use `chage -l` for that.

8.  Exit the remote session:

    ``` bash
    exit
    ```

## Why these commands?

  -----------------------------------------------------------------------
  Command                             What it does
  ----------------------------------- -----------------------------------
  `ssh <user>@stapp02`                Opens an SSH session to App Server
                                      2

  `hostname`                          Confirms the remote machine

  `whoami`                            Confirms the current account

  `sudo useradd -e 2027-04-15 ravi`   Creates `ravi` with the requested
                                      account expiry

  `id ravi`                           Displays the user's UID, primary
                                      GID, and groups

  `sudo chage -l ravi`                Displays password-aging and
                                      account-expiration information

  `getent passwd ravi`                Looks up the user's account record

  `exit`                              Closes the remote session
  -----------------------------------------------------------------------

## Verification and troubleshooting

### User already exists

If `useradd` reports:

``` text
useradd: user 'ravi' already exists
```

Do not repeatedly try to create the same account. Inspect it:

``` bash
id ravi
sudo chage -l ravi
```

If the account exists but has the wrong expiration date, an authorized
administrator can update it:

``` bash
sudo chage -E 2027-04-15 ravi
```

### Wrong server

If `hostname` does not return `stapp02`, stop and reconnect to the
correct server before changing anything.

### `sudo` permission denied

Confirm that the account supplied by the lab is authorized to use
`sudo`. Follow the infrastructure instructions rather than trying to
bypass permissions.

### Expiration date is incorrect

Inspect the account-aging details:

``` bash
sudo chage -l ravi
```

If needed, correct the account expiration with `chage -E`.

## Key learnings

-   A jump host provides an entry point to servers on a private network.
-   SSH securely connects to a remote machine.
-   Always verify the hostname before making administrative changes.
-   Linux account records are maintained through files including
    `/etc/passwd` and `/etc/shadow`.
-   `/etc/shadow` stores account expiration and password-aging
    information.
-   `sudo` runs an authorized command with elevated privileges.
-   `useradd` creates a Linux user.
-   `useradd -e YYYY-MM-DD username` creates a user with an account
    expiration date.
-   `chage -l username` displays account-aging information, including
    account expiration.
-   `chage -E` controls account expiration; `chage -M` controls maximum
    password age.
-   Account expiration is not the same as deleting a user or expiring
    their password.
-   Verify the account with `id` and its expiry with `chage -l`.

## Final verification checklist

-   [ ] Connected to App Server 2 (`stapp02`).
-   [ ] Created the lowercase user `ravi`.
-   [ ] Set the account expiration date to `2027-04-15`.
-   [ ] Confirmed the user exists with `id ravi`.
-   [ ] Confirmed the expiry with `sudo chage -l ravi`.

**Completion status:** Mark this lab complete only after the commands
have been run on `stapp02` and the expiration date has been verified.
