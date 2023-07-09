#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "veuillez siasir un répertoire et une date en paramètre"
    exit 1
fi

rep_base=$1
date_var=$2
error_log="$rep_base/error_$date_var.log"

if [ ! -f "$error_log" ]; then
    echo "Fichier d'erreur introuvable"
    exit 1
fi

mise_en_forme() {

    while read line; do
        line=${line//Mon/Lun}
        line=${line//Tue/Mar}
        line=${line//Wed/Mer}
        line=${line//Thu/Jeu}
        line=${line//Fri/Ven}
        line=${line//Sat/Sam}
        line=${line//Sun/Dim}

        line=${line//Feb/Fev}
        line=${line//Apr/Avr}
        line=${line//May/Mai}
        line=${line//Jun/Jui}
        line=${line//Jul/Jui}
        line=${line//Aug/Aou}

        line=${line//[][]:/}
        line=${line//,/}
        line=${line//\[/}
        line=${line//\]/}
        line=${line//:/ }

        echo $line
    done <$error_log

}

sortie_imp() {

    rep_sortie="$rep_base/sortie_$date_var"
    if [ ! -d "$rep_sortie" ]; then
        mkdir "$rep_sortie"
    fi

    while read line; do
        line=${line//Mon/Lun}
        line=${line//Tue/Mar}
        line=${line//Wed/Mer}
        line=${line//Thu/Jeu}
        line=${line//Fri/Ven}
        line=${line//Sat/Sam}
        line=${line//Sun/Dim}

        line=${line//Feb/Fev}
        line=${line//Apr/Avr}
        line=${line//May/Mai}
        line=${line//Jun/Jui}
        line=${line//Jul/Jui}
        line=${line//Aug/Aou}

        line=${line//[][]:/}
        line=${line//,/}
        line=${line//\[/}
        line=${line//\]/}
        line=${line//:/ }

        echo $line >>$rep_sortie/sortie.imp
    done <$error_log

}

nombre_erreurs() {
    count=$(grep -c "" $error_log)
    echo "Nombre de différente erreurs le $date_var: $count"
}

nombre_erreurs_type() {
    types=$(grep "" $error_log | awk '{print $6}' | sort | uniq)
    count=$(echo "$types" | wc -l)
    echo "Nombre de différent type d'erreurs le $date_var: $count"
}

erreur_par_ip() {
    IP=$1
    errors=$(grep "" $error_log | grep "$IP" | awk '{print $1 " " $2 " " $3 " " $5 " " $6 " " $7}')

    if [ -z "$errors" ]; then
        echo "Pas d'erreur trouvé pour l'adresse ip"
        return
    fi

    echo "$errors"
}

erreur_par_pid() {
    PID=$1
    errors=$(grep "" $error_log | grep "$PID" | awk '{print $1 " " $2 " " $3 " " $5 " " $6 " " $7}')

    if [ -z "$errors" ]; then
        echo "Pas d'erreur trouvé pour le pid"
        return
    fi

    echo "$errors"
}

erreur_par_type() {
    TYPE=$1
    errors=$(grep "" $error_log | grep "$TYPE" | awk '{print $1 " " $3 " " $4 " " $7}')

    if [ -z "$errors" ]; then
        echo "Pas d'erreur trouvé pour le type d'erreur"
        return
    fi
    echo "$errors"
}

while true; do
    echo "--- Statistique pour le fichier error_$date_var.log ---"
    echo "1. Formater les erreur"
    echo "2. Crée un fichier .imp avec les erreurs formater"
    echo "3. Compter le nombre d’erreurs"
    echo "4. Compter le nombres de type d’erreurs différents"
    echo "5. Obtenir les erreurs pour une adresse IP"
    echo "6. Obtenir les erreur pour un pid"
    echo "7. Obtenir les erreur pour un type d'erreur"
    echo "8. Quitter"
    read -p "Entrer votre choix: " choice
    case $choice in
    1) mise_en_forme ;;
    2) sortie_imp ;;
    3) nombre_erreurs ;;
    4) nombre_erreurs_type ;;
    5)
        read -p "Entrer une adresse IP: " ip
        erreur_par_ip "$ip"
        ;;
    6)
        read -p "Entrer un PID: " pid
        erreur_par_pid "$pid"
        ;;
    7)
        read -p "Enter un type d'erreur: " erreur_type
        erreur_par_type "$erreur_type"
        ;;
    8) exit 0 ;;
    *) echo "Choix invalide veuillez réessayer : " ;;
    esac
done
