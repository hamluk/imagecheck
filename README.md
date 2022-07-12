# imagecheck

## Introduction

This project is part of the final project for the course Software Security held by the University of Naples Federico II. Its purpose is to work out a practical approach about software security and will lead to a following discussion about the realted securtiy topics.

## How to use

`script usage: imagecheck.sh [-d <path_to_docker_compose_folder>] [-i <path_to_cve_file>] [-h]`

The script `imagecheck.sh` is the entrance point of the project. It uses the `anchore/grype` open-source vulnerability scanner and can therfore be used to find known vulnerabilities of docker images. 

#### Options

##### -d

This command line option can be used to immediately run a docker compose up command to start a following app after scanning its underlaying docker image. For the value `<path_to_docker_compose_folder`, the user must provide the script with a valid path to a folder storing a 'docker-compose.yaml' file.

##### -i

This command line option can be used to pass the script a file containing CVE IDs that the user wants to check the image vulnerabilities for. The script will add the encountered times of all given CVE ids to the output.

##### -h

Displays how to use the script on the command line.