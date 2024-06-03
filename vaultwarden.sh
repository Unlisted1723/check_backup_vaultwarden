#!/bin/bash
set -eu -o pipefail

VW_ROOT="/srv/docker/vaultwarden"
LOG="${VW_ROOT}"/data/vaultwarden.log
DOCKER="docker compose"
NAGIOS=""
FILE="exit_status.txt"
SRC_PATH="/srv/docker/docker_vaultwarden/"${FILE}""
DEST_PATH="/u01/app/nagios/var/"

rm -f ${FILE}
touch ${FILE}

trap on_exit ERR EXIT
 
log () {
    echo "$@" | tee -a "${LOG}"
}

err () { 
    log "$@"
    exit 1 
    }

on_exit() {
    ret=$?
    if [ $ret -ne 0 ]; then
        err "Une erreur est survenue. Vérifiez le fichier de log pour plus de détails."
	ssh  -i /root/.ssh/id_rsa 'rm -f /u01/app/nagios/var/exit_status.txt'
    else
        log "OK - Le script s'est exécuté correctement."
        ssh  -i /root/.ssh/id_rsa 'rm -f /u01/app/nagios/var/exit_status.txt'
	RSYNC_RSH='ssh ' rsync -avz /srv/docker/docker_vaultwarden/exit_status.txt @:/u01/app/nagios/var/
    fi
    exit ${ret}
}


# Enregistrement de la date d'exécution
log "Script vaultwarden.sh exécuté le $(date)"

# Renommage et suppression de l'ancienne sauvegarde de données
cd "${VW_ROOT}"/fulldata-backup || exit 1
rm -rf data-1
mv data data-1

# Consignation dans le fichier de log
if [ $? -ne 0 ]; then
    err "Échec du renommage et de la suppression de l'ancienne sauvegarde."
else
    log "Renommage et suppression de l'ancienne sauvegarde réussis."
fi

# Arrêt et suppression des conteneurs orphelins
if ! ${DOCKER} -f "${VW_ROOT}"/docker-compose.yml down --remove-orphans; then
    err "Échec de l'arrêt des conteneurs."
else
    log "Arrêt des conteneurs réussi." 
fi

# Mise à jour des images Docker
if ! ${DOCKER} -f "${VW_ROOT}"/docker-compose.yml pull; then
    err "Échec de la mise à jour des images Docker."
else
    log "Mise à jour des images Docker réussie."
fi

# Redémarrage des conteneurs
if ! ${DOCKER} -f "${VW_ROOT}"/docker-compose.yml up -d; then
    err "Échec du redémarrage des conteneurs Docker."
else
    log "Redémarrage des conteneurs Docker réussi."
fi

# Copie des données
if ! cp -rp "${VW_ROOT}"/data "${VW_ROOT}"/fulldata-backup; then
    err "Échec de la copie des données."
else
    log "Copie des données réussie."
fi

exit 0
