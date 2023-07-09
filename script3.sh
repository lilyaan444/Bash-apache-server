#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "veuillez siasir un répertoire et un mois en paramètre"
  exit 1
fi

rep_base=$1
mois_var=$2

nb_requete_ip() {
  IP=$1

  NB_REQUETE=$(grep $IP $rep_base/access.log | grep $mois_var | awk '{print $4}' | sort | wc -l)
  echo "Nombre de différentes requêtes faites par $IP le mois de $mois_var: $NB_REQUETE"
}

nb_requete_heure() {

  grep $mois_var $rep_base/access.log | awk '{print $3}' | cut -d: -f2 | sort | uniq -c
}

code_etat_user() {
  USER=$1

  grep $USER $rep_base/access.log | grep $mois_var | awk '{print $9, $10}' | sort | uniq -c | wc -l
}

ip_utilisateur() {
  USER=$1

  grep $USER $rep_base/access.log | grep $mois_var | awk '{print $1}' | sort | uniq
}

while true; do
  echo "--- Statistique pour le mois de $mois_var ---"
  echo "1. Obtenir nombre de requêtes différentes faites par une adresse IP"
  echo "2. Obtenir le nombre de requêtes différentes par heure"
  echo "3. Obtenir le nombre de codes d'état différents par utilisateur"
  echo "4. Obtenir les adresses IP différentes d'un utilisateur"
  echo "5. Quitter"
  read -p "Entrez votre choix : " choix
  case $choix in
  1)
    read -p "Entrez l'adresse IP : " ip
    nb_requete_ip $ip
    ;;
  2)
    nb_requete_heure
    ;;
  3)
    read -p "Entrez l'utilisateur : " user
    code_etat_user $user
    ;;
  4)
    read -p "Entrer un nom d'utilisateur " utilisateur
    ip_utilisateur "$utilisateur"
    ;;
  5)
    break
    ;;
  *)
    echo "Option invalide"
    ;;
  esac
done
