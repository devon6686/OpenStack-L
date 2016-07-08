#!/bin/bash
mysql -e "delete from mysql.user where host='{{ HOST }}';flush privileges;"
