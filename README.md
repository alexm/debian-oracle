Oracle Database 12c Release 1 (12.1)
====================================

* [DataBase Oracle in Debian Wiki](https://wiki.debian.org/DataBase/Oracle)
* [Database Quick Installation Guide](http://docs.oracle.com/database/121/LTDQI/toc.htm)
  * `uname -m` => `x86_64`
  * 1 GB RAM
  * 6.1 GB disk free
  * 1 GB free /tmp
  * packages:
```
build-essential
binutils
libcap-dev
gcc
g++
libc6-dev
ksh
libaio-dev
make
libxi-dev
libxtst-dev
libxau-dev
libxcb1-dev
sysstat
rpm
xauth
```

```
sudo addgroup --system oinstall
sudo addgroup --system dba
sudo adduser --system --ingroup oinstall --shell /bin/bash oracle
sudo adduser oracle dba
sudo passwd oracle
sudo su - oracle
echo "umask 022" > ~/.bashrc
chmod +x ~/.bashrc
```

/etc/sysctl.d/local-oracle.conf
```
fs.file-max = 65536
fs.aio-max-nr = 1048576
# semaphores: semmsl, semmns, semopm, semmni
kernel.sem = 250 32000 100 128
# (Oracle recommends total machine Ram -1 byte)
kernel.shmmax = 2147483648
kernel.shmall = 2097152
kernel.shmmni = 4096
net.ipv4.ip_local_port_range = 1024 65000
vm.hugetlb_shm_group = 11s0
vm.nr_hugepages = 64
```

/etc/security/limits.d/local-oracle.conf
```
oracle          soft    nproc           2047
oracle          hard    nproc           16384
oracle          soft    nofile          1024
oracle          hard    nofile          65536
```

nasty hacks:
```
sudo ln -s /usr/bin/awk /bin/awk
sudo ln -s /usr/bin/basename /bin/basename
sudo ln -s /usr/bin/rpm /bin/rpm
sudo ln -s /usr/lib/x86_64-linux-gnu /usr/lib64
```

install:
```
su -
mkdir -p /u01/app/
chown -R oracle:oinstall /u01/app/
chmod -R 775 /u01/app/
```

Start Oracle
------------

```
oracle@debian-sid:~$ . /usr/local/bin/oraenv 
ORACLE_SID = [orcl] ? 
The Oracle base remains unchanged with value /u01/app/oracle
oracle@debian-sid:~$ lsnrctl start

LSNRCTL for Linux: Version 12.1.0.2.0 - Production on 30-OCT-2015 19:28:03

Copyright (c) 1991, 2014, Oracle.  All rights reserved.

Starting /u01/app/oracle/product/12.1.0/dbhome_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 12.1.0.2.0 - Production
System parameter file is /u01/app/oracle/product/12.1.0/dbhome_1/network/admin/listener.ora
Log messages written to /u01/app/oracle/diag/tnslsnr/debian-sid/listener/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=127.0.0.1)(PORT=1521)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 12.1.0.2.0 - Production
Start Date                30-OCT-2015 19:28:05
Uptime                    0 days 0 hr. 0 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /u01/app/oracle/product/12.1.0/dbhome_1/network/admin/listener.ora
Listener Log File         /u01/app/oracle/diag/tnslsnr/debian-sid/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=127.0.0.1)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
The listener supports no services
The command completed successfully
oracle@debian-sid:~$ dbstart 
ORACLE_HOME_LISTNER is not SET, unable to auto-start Oracle Net Listener
Usage: /u01/app/oracle/product/12.1.0/dbhome_1/bin/dbstart ORACLE_HOME
Processing Database instance "orcl": log file /u01/app/oracle/product/12.1.0/dbhome_1/startup.log
oracle@debian-sid:~$ 

```

Add User
--------

```
SQL> CREATE USER c##scott IDENTIFIED BY tiger ;

User created.

SQL> GRANT ALL PRIVILEGES TO c##scott;

Grant succeeded.

SQL> CREATE USER c##foo IDENTIFIED BY bar;

User created.

SQL> GRANT ALL PRIVILEGES TO c##foo;

Grant succeeded.

SQL> 
```

DBD::Oracle
-----------

```
su - oracle -c "echo 'bequeath_detach = yes' >> /u01/app/oracle/product/12.1.0/dbhome_1/network/admin/sqlnet.ora"
source /usr/local/bin/oraenv
wget https://cpan.metacpan.org/authors/id/P/PY/PYTHIAN/DBD-Oracle-1.74.tar.gz
tar xf DBD-Oracle-1.74.tar.gz
cd DBD-Oracle-1.74
perl Makefile.PL
make
make test ORACLE_USERID='c##scott/tiger' ORACLE_USERID_2='c##foo/bar'
```
