#! /bin/bash

echo "-----------------"
echo "Starting imagecheck..."

echo ""
docker images
echo ""

read -p "Enter image name <image:tag> to test: " IMAGE
read -p "Enter filename to store vulnarablities of $IMAGE: " LOGFILE
read -p "Enter severity level (Negligible, Medium, High, Critical) you want to check on: [High] " SEVERITY_LEVEL

if [ -z "$SEVERITY_LEVEL" ]
then 
    SEVERITY_LEVEL="High"
fi

./severitycheck.sh $IMAGE $LOGFILE $SEVERITY_LEVEL
result=$?

echo "Ending imagecheck"
echo "-----------------"