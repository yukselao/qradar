#!/bin/bash

echo "INFO indexleri temizleyip, search yap, data file counter>0 kontrolu gerceklestir. Eger data file counter 0'dan buyukse index'ler kullanilmiyor demektir."
./qactl -d "2021/12/31 11:00" 60
for searchid in $(./qactl -listallsearches |grep 551955 | cut -d';' -f2 |cut -d'=' -f2); do ./qactl -deletesearch $searchid; done;
./qactl -checkdatafilecount 551955 "2021-12-31 10:00:00" "2021-12-31 10:59:00" 0.5.0.1
