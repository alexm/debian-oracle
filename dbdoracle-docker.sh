if ! test -f /.dockerenv
then
    exec docker run --rm -it -v $PWD:/usr/src -w/usr/src ubuntu:jammy bash
fi
apt update
apt install git wget fakeroot alien devscripts vim-nox
git clone https://salsa.debian.org/perl-team/modules/packages/libdbd-oracle-perl.git
cd libdbd-oracle-perl
wget https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-basic-linuxx64.rpm
# wget https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-basiclite-linuxx64.rpm
wget https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-devel-linuxx64.rpm
fakeroot alien --scripts *.rpm
apt install ./oracle-instantclient-*.deb
apt build-dep .
export DEBEMAIL="alexm@debian.org"
export DEBFULLNAME="Alex Muntada"
export EDITOR=vim
dch -l foobar -D jammy "Backport for jammy"
dpkg-buildpackage -b
ls -ltr ../libdbd-oracle-perl_*.deb
