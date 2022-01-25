touch createdb.sql
echo "CREATE DATABASE ${DB_NAME} DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.*  TO ${DB_USER}@'%' WITH GRANT OPTION;" >> createdb.sql

mysql --host ${HOST} --user ${DB_ADMIN} -P 3306 -p${DB_ADMIN_PASS} --ssl=true< createdb.sql