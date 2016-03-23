Selinux user script



There are five main SELinux user types (and a handy chart in the Fedora documentation):

   **guest_u:** – no X windows, no sudo, and no networking

   **xguest_u:** – same as guest_u, but X is allowed and connectivity is allowed to web ports only (handy for kiosks)

   **user_u:** – same as xguest_u, but networking isn’t restricted JUMP USERS MUST HAVE THIS USER TYPE

   **staff_u:** – same as user_u, but sudo is allowed (su isn’t allowed)

   **unconfined_u:** – full access (this is the default)

Creation of account
Create user

```
useradd -Z user_u john
```

Change restriction if user is not user_u role

```
semanage login -a -s user_u
```

Deletion of account
Delete user (completely)

```
userdel -r
```
