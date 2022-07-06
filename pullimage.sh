#! /bin/bash

function exit_script {
    exit $1
}

IMAGE=$1

if ! docker image inspect $IMAGE &> /dev/null
then
    echo "Image $IMAGE not found on local machine"
    check=1
    read -p "Do you want to pull image $IMAGE to local machine? [y/n] " yn
    while (( $check ))
    do 
        case $yn in
            [Yy])
                echo "Pulling image..."
                resp=$( { docker pull $IMAGE; } 2>&1 )
                if [[ $resp == *"Error response"* ]]
                then
                    echo $resp
                    exit_script 1
                fi
                check=0
                ;;
            [nN])
                echo "Please pull $IMAGE locally before testing it wit anchore/grype"
                echo "Exiting script..."
                check=0
                exit_script 1
                ;;
            *)
                echo "Please enter [y/n]"
                read -p "Do you want to pull image $IMAGE to local machine? [y/n] " yn
                ;;
        esac
    done
fi

exit_script 0