#!/bin/bash

# survey questions
echo "What is your favorite color?"
read COLOR
echo "What would your spirit animal be?"
read ANIMAL
echo "What is your favorite food?"
read FOOD
echo "How many countries have you been to besides the US?"
read COUNTRIES
echo "How many languages can you speak?"
read LANGUAGES

# get the current time/date 
TIMESTAMP=`date --iso-8601=seconds`

# convert data to tmp.csv and generate random UID for each instance
echo "$RANDOM$RANDOM,$TIMESTAMP,$COLOR,$ANIMAL,$FOOD,$COUNTRIES,$LANGUAGES" > ./tmp.csv
# read data in tmp.csv
cat ./tmp.csv
# send to database script
bash ./database.sh
# remove tmp.csv
rm ./tmp.csv
