backupname=$MYSQL_DATABASE-$(date -Iseconds -u)
echo "Creating backup" $backupname

port=3306
if [ ! -z "$MYSQL_PORT" ]
then
	port=$MYSQL_PORT
fi

mysqldump -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_HOST -P $port --databases $MYSQL_DATABASE > $backupname.sql
echo "Storing backup"
tar -zcvf $backupname.tgz $backupname.sql

if [[ -z "${MINIO_HOST}" ]]; then
    cp $backupname.tgz /backup/
else
	mc config host add minio $MINIO_HOST $MINIO_ACCESS_KEY $MINIO_SECRET_KEY
	mc cp $backupname.tgz minio/$MINIO_BACKUP_BUCKET
fi
echo "Completed" $backupname