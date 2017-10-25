#!/bin/bash

if [ "$(whoami)" != "root" ]
then
    retcode=$( grep "docker:" /etc/group | grep -c "$(whoami)" )
    if [ $retcode -eq 0 ]
    then
        echo "[ ERREUR ] Votre compte utilisateur n'appartient pas au groupe unix "docker" !"
        echo "  -> Veuillez contacter l'administrateur du serveur pour cette demande !"
        exit 1
    fi
fi

FULL_PATH=$( dirname $(readlink -f $0) )
ansible-playbook -s ${FULL_PATH}/site.yml -i ${FULL_PATH}/inventories/jenkins.hosts -t copy-libs-to-docker-jenkins
if [ $? -eq 0 ]
then
    echo "[  OK  ] Copying libs to the Docker Jenkins."
else
    echo "[ ERREUR ] Unable to copy libs to the Docker Jenkins !"
    exit 1
fi

exit 0
