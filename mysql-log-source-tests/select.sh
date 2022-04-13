#!/bin/bash
mysql -h 10.10.5.14 -u testdbuser -p'9yLX795du%8b' testdb -e 'select * from user order by id desc limit 10'
