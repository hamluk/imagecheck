#! /bin/bash

function exit_script {
    exit $1
}

LOG_FOLDER="./logs/"
GRYPE_CMD="grype"
IMAGE=$1
LOGFILE=$2
SEVERITY_LEVEL=$3
DOCKER_ENABLE_BIT=$4
DOCKER_COMPOSE_PATH=$5
CVE_ENABLE_BIT=$6
CVELOG_PATH=$7
LOGFILE_PATH=${LOG_FOLDER}${LOGFILE}
SEVERITY_COUNT=0
CVE_COUNT=0

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

if [ $CVE_ENABLE_BIT -gt 0 ]
then
    while IFS=$'\r' read line
    do  
        cve_array[$i]=$line
        ((i++))
    done < "$CVELOG_PATH"
fi

input=$LOGFILE_PATH
while IFS= read -r line
do
    if [ $CVE_ENABLE_BIT -gt 0 ]
    then

        for i in "${cve_array[@]}"
        do
           
            if [[ $line == *"$i"* ]]
            then
                ((CVE_COUNT++))
            fi
        done
    fi

    if [[ $line == *"$SEVERITY_LEVEL"* ]]
    then
        ((SEVERITY_COUNT++))
    fi
done < "$input"

echo "A total number of $SEVERITY_COUNT vulnerabilities with $SEVERITY_LEVEL severity level found!"

if [ $CVE_ENABLE_BIT -gt 0 ]
then
    echo "Encountered the given CVEs $CVE_COUNT time(s) in the $LOGFILE log file!" 
fi

if [[ $SEVERITY_COUNT -gt 0 && $DOCKER_ENABLE_BIT -eq 1 ]]
then
    check=1
    read -p "Do you still want to start docker-compose up? [y/n] " yn
    while (( $check ))
    do 
        case $yn in
            [Yy])
                cd ${DOCKER_COMPOSE_PATH}
                eval "docker-compose up"
                check=0
                ;;
            [nN])
                check=0
                exit_script 1
                ;;
            *)
                echo "Please enter: [y/n]"
                read -p "Do you still want to start docker-compose up? [y/n] " yn
                ;;
        esac
    done
fi

exit_script 0