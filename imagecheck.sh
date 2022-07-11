#! /bin/bash

echo "-----------------"
echo "Starting imagecheck..."

echo ""
docker images
echo ""

read -p "Enter image name <image:tag> to test: " IMAGE
read -p "Enter filename to store vulnarablities of $IMAGE: " LOGFILE
check=1
read -p "Enter severity level (Negligible, Medium, High, Critical) you want to check on: [High] " SEVERITY_LEVEL
while (( $check ))
do
    if [[ "$SEVERITY_LEVEL" =~ ^(Negligible|Medium|High|Critical)$ ]]
    then 
        check=0 
    else 
        echo "Please enter one of the following options: Negligible, Medium, High, Critical"
        read -p "Enter severity level (Negligible, Medium, High, Critical) you want to check on: [High] " SEVERITY_LEVEL
    fi
done

if [ -z "$SEVERITY_LEVEL" ]
then 
    SEVERITY_LEVEL="High"
fi

./severitycheck.sh $IMAGE $LOGFILE $SEVERITY_LEVEL
result=$?

echo "Ending imagecheck"
echo "-----------------"