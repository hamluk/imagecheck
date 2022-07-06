#! /bin/bash

function exit_script {
    echo "Exiting severitycheck script"
    exit $1
}

GRYPE_CMD="grype"
SEVERITY_LEVEL="high"

echo "Entering severitycheck script..."
echo ""
docker images
echo ""

read -p "Enter image name <image:tag> to test: " IMAGE

./pullimage.sh $IMAGE 

result=$?

if (( $result )); then exit_script 1; fi

read -p "Enter filename to store vulnarablities of $IMAGE: " LOGFILE
read -p "Enter severity level you want to check on: [high] " SEVERITY_LEVEL

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

if ! $GRYPE_CMD $IMAGE --fail-on $SEVERITY_LEVEL > $LOGFILE 
then
    echo "found severity with level => $SEVERITY_LEVEL"
    exit_script 1
fi

exit_script 0