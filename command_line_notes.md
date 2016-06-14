# Command-Line Notes

## Users

To add a single user:

```{sh}
sudo adduser -m --create-home <username>
sudo passwd <username>
```

Make a user a sudoer:

```{sh}
sudo adduser <username> sudo
```

## Groups

Creating a group:

```{sh}
sudo groupadd <groupname>
```

Add a user to a group:

```{sh}
sudo adduser <username> <groupname>
```

## Make a Common Directory

We will make a directory in which instructors can place materials.  Anyone can read the files in this directory (and execute them if need be), but only instructors can write to this directory.

Assume you have made an `instructors` group.

```{sh}
sudo mkdir /com
sudo chmod -R 775 /com
sudo chown -R :instructors /com
```