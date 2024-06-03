# docker_vaulwarden



## Prérequis
- Avoir accès au serveur (Vaultwarden).
- Avoir accès au serveur (Nagios).

## Lancement
- Une cron sur Vaultwarden exécute le script `vaultwarden.sh` tout les 7 jours, il est possible de l'exécuter manuellement.

        ## Exécution classique

        Execution clasique :   
        
        > /srv/docker/docker_vaulwarden# ./vaultwarden.sh  
        > Script vaultwarden.sh exécuté le ${TIME}  
        > Renommage et suppression de l'ancienne sauvegarde réussis.  
        > [+] Running 2/2  
        >  ✔ Container vaultwarden          Removed                                                                                                                                                                                                 5.2s  
        >  ✔ Network vaultwarden_default        Removed                                                                                                                                                                                                 0.2s  
        > Arrêt des conteneurs réussi.  
        > [+] Pulling 1/1  
        >  ✔ vaultwarden   Pulled                                                                                                                                                                                                  1.1s  
        > Mise à jour des images Docker réussie.  
        > [+] Running 2/2  
        >  ✔ Network vaultwarden_default   Created                                                                                                                                                                                                 0.1s   
        >  ✔ Container vaultwarden          Started                                                                                                                                                                                                 0.4s  
        > Redémarrage des conteneurs Docker réussi.  
        > Copie des données réussie.  

- Nagios execute le script check_vault.sh toute les 5 minutes  

  - Quand le script vaultwarden.sh est éxécuter et que tout est ok alors il crée le fichier exit_status.txt sur le serveur Nagios,si le script ne c'est pas bien exécuter le fichier n'est pas crée.  
  - Si ce fichier est présent alors Nagios remmonte OK, sinon Nagios remmonte Critical
