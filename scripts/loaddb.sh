if [ -f /var/sqldump/database.sql ];
then
    DATE=$(date +"%Y%m%d%H%M")

    mysql -uroot -proot devdb < /var/sqldump/database.sql
    mv /var/sqldump/database.sql /var/sqldump/$DATE-imported.sql
fi
