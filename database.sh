#!/bin/bash

# set variables for credentials
USER=root
PASSWORD=changethis
# set database and table names
DATABASE=survey
TABLE=tblSurvey

# copy data in the secure directory
sudo cp ./tmp.csv /var/lib/mysql-files/

# cases for when database does and does not exist
DBCHECK=`mysql -u"$USER" -p"$PASSWORD" -e "show databases;" | grep -Fo $DATABASE`
if [ "$DBCHECK" == "$DATABASE" ]; then
   echo "Database already exists. No need to create a new one."
else
   echo "Database does not exist. Creating new database..."
   mysql -u"$USER" -p"$PASSWORD" -e "CREATE DATABASE $DATABASE"
fi
# create table if it doesn't already exist
DBCHECK=`mysql -u"$USER" -p"$PASSWORD" -e "show tables;" $DATABASE | grep -Fo $TABLE`
if [ "$DBCHECK" == "$TABLE" ]; then
  echo "Table already exists. No need to create a new one."
else
  echo "Table does not exist. Creating new table..."
   mysql -u"$USER" -p"$PASSWORD" -e "CREATE TABLE $TABLE (ID VARCHAR(255), Date TIMESTAMP, Color VARCHAR(255), SpiritAnimal VARCHAR(255), Food VARCHAR(255), Countries varchar(255), Languages VARCHAR(255)); ALTER TABLE $TABLE ADD PRIMARY KEY (ID);" $DATABASE
fi
# write data from tmp.csv into table
echo "Adding the entry..."
mysql -u"$USER" -p"$PASSWORD" -e "LOAD DATA INFILE '/var/lib/mysql-files/tmp.csv' INTO TABLE $TABLE FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';" $DATABASE
# dump current version of database into export file
mysqldump -u"$USER" -p"$PASSWORD" $DATABASE > `date --iso-8601`-$DATABASE.sql
# remove /var/lib/mysql-files/tmp.csv
sudo rm /var/lib/mysql-files/tmp.csv

# final output
echo "Entry added."