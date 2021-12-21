#!/bin/bash

ppwd=$(pwd)
rm -fr gzip test.tar.gz test.tar
rm -fr lz4 test.tar.lz4
mkdir -p gzip lz4
backupsource=(/store/ariel/events/records/aux/1/$1 /store/ariel/events/payloads/aux/1/$1)

echo --gzip test--
echo INFO tar -pcf test.tar ${backupsource[@]} --exclude super --exclude lucene
time (tar -pcf test.tar ${backupsource[@]} --exclude super --exclude lucene &>/dev/null)
echo
echo INFO gzip -9 test.tar
time gzip -9 test.tar
du -sh test.tar.gz
tar -zxf test.tar.gz -C gzip/
du -sh gzip/
echo

echo --lz4 test--
echo "INFO tar -cvf - ${backupsource[@]} --exclude super --exclude lucene | lz4 - test.tar.lz4"
time (tar -cf - ${backupsource[@]} --exclude super --exclude lucene | lz4 - test.tar.lz4 &>/dev/null)
du -sh test.tar.lz4
mv test.tar.lz4 lz4/
cd lz4/
lz4 -dc --no-sparse test.tar.lz4 | tar xf -
mv test.tar.lz4 ../
cd $ppwd
du -sh lz4/
