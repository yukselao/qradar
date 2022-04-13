#!/bin/bash
for i in $(seq 1 $1); do
        mysql -h 10.10.5.14 -u testdbuser -p'9yLX795du%8b' testdb << EOF
INSERT INTO user (employee_id, user_type, username, password) VALUES (NULL, 'testuser$i', 'testuser', 'testpassword');
EOF
        sleep $2
done
