#! /bin/bash

function usage {
    echo "script usage: $(basename $0) [-d <path_to_docker_compose_folder>] [-i <path_to_cve_file>] [-h]" >&2
}

DOCKER_ENABLE_BIT=0
DOCKER_COMPOSE_PATH="null"
CVE_ENABLE_BIT=0
CVELOG_PATH="null"

while getopts 'd:i:h' OPTION; do
  case "$OPTION" in
    d)
      DOCKER_ENABLE_BIT=1
      DOCKER_COMPOSE_PATH=$OPTARG
      ;;
    i)
      CVE_ENABLE_BIT=1
      CVELOG_PATH=$OPTARG
      ;;
    h)
      usage
	  exit 0
      ;;
    ?)
      usage 
      exit 1
      ;;
  esac
done


echo "-----------------"
echo "Starting imagecheck..."

echo ""
docker images
echo ""

read -p "Enter image name <image:tag> to test: " IMAGE
read -p "Enter filename to store vulnarablities of $IMAGE: " LOGFILE
check=1
read -p "Enter severity level [Negligible|Medium|High|Critical] you want to check on: [High] " SEVERITY_LEVEL
if [ -z "$SEVERITY_LEVEL" ]
then 
    SEVERITY_LEVEL="High"
fi

while (( $check ))
do
    if [[ "$SEVERITY_LEVEL" =~ ^(Negligible|Medium|High|Critical)$ ]]
    then 
        check=0 
    else 
        echo "Please enter one of the following options: [Negligible|Medium|High|Critical]"
        read -p "Enter severity level [Negligible|Medium|High|Critical] you want to check on: [High] " SEVERITY_LEVEL
    fi
done

./severitycheck.sh $IMAGE $LOGFILE $SEVERITY_LEVEL $DOCKER_ENABLE_BIT $DOCKER_COMPOSE_PATH $CVE_ENABLE_BIT $CVELOG_PATH
result=$?

echo "Ending imagecheck"
echo "-----------------"