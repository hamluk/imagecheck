#! /bin/bash

function exit_script {
    echo "Exiting severitycheck script"
    exit $1
}

LOG_FOLDER="./logs/"
GRYPE_CMD="grype"
IMAGE=$1
LOGFILE=$2
SEVERITY_LEVEL=$3
LOGFILE_PATH=${LOG_FOLDER}${LOGFILE}
SEVERITY_COUNT=0

echo "Entering severitycheck script..."

./pullimage.sh $IMAGE 

result=$?

if (( $result )); then exit_script 1; fi

echo "Choosen image to be checked $IMAGE" 

if command -v $GRYPE_CMD &> /dev/null
then
    echo "saving logs to file $LOGFILE"
    echo "checking image with anchore/grype..."
else
    echo "anchore/grype is not installed"
    echo "intalling anchore/grype to local machine"
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
fi

$GRYPE_CMD $IMAGE --fail-on $SEVERITY_LEVEL > $LOGFILE_PATH

input=$LOGFILE_PATH
while IFS= read -r line
do
    if [[ $line == *"$SEVERITY_LEVEL"* ]]
        then
            ((SEVERITY_COUNT++))
        fi
done < "$input"

echo "A total number of $SEVERITY_COUNT vulnerabilities found!"

# if ! $GRYPE_CMD $IMAGE --fail-on $SEVERITY_LEVEL > ${LOG_FOLDER}${LOGFILE}
# then
#     echo "found severity with level => $SEVERITY_LEVEL"
#     exit_script 1
# fi

exit_script 0