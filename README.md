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
