#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "veuillez siasir un répertoire et une date en paramètre"
  exit 1
fi

rep_base=$1
date_var=$2

nb_requete_ip() {
  IP=$1

  NB_REQUETE=$(grep $IP $rep_base/access.log | grep $date_var | awk '{print $4}' | sort | wc -l)
  echo "Nombre de différentes requêtes faite par $IP le $date_var: $NB_REQUETE"
}

nb_requete_heure() {

  grep $date_var $rep_base/access.log | awk '{print $3}' | cut -d: -f2 | sort | uniq -c
}

code_etat_user() {
  USER=$1

  grep $USER $rep_base/access.log | grep $date_var | awk '{print $9, $10}' | sort | uniq -c | wc -l

}

ip_utilisateur() {
  USER=$1
  grep $USER $rep_base/access.log | grep $date_var | awk '{print $1}' | sort | uniq
}

while true; do
  echo "--- Statistique pour $date_var ---"
  echo "1. Obtenir nombre de requêtes différentes faites par une adresse IP"
  echo "2. Obtenir le nombres de requêtes par heure"
  echo "3. Obtenir le nombre de codes d'état différents par utilisateur"
  echo "4. Obtenir les différentes IPs d'un utilisateur"
  echo "5. Quitter"
  read -p "Entrer un choix: " choix
  case $choix in
  1)
    read -p "Entrez un adresse IP : " ip
    nb_requete_ip "$ip"
    ;;
  2)
    nb_requete_heure
    ;;
  3)
    read -p "Entrer un nom d'utilisateur " utilisateur
    code_etat_user "$utilisateur"
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
