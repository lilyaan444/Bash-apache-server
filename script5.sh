#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "veuillez siasir un répertoire et un mois en paramètre"
    exit 1
fi

rep_base=$1
mois_var=$2

fich_erreur=($(find $rep_base -name "error_*$mois_var*.log"))
if [ ${#fich_erreur[@]} -eq 0 ]; then
    echo "Fichier d'erreur introuvable"
    exit 1
fi

mise_en_forme() {

    for error_log in "${fich_erreur[@]}"; do
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
    done
}

sortie_imp() {

    rep_sortie="$rep_base/sortie_mois_$mois_var"
    if [ ! -d "$rep_sortie" ]; then
        mkdir "$rep_sortie"
    fi

    for error_log in "${fich_erreur[@]}"; do
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
    done
}

nombre_erreurs() {
    count=0
    for error_log in "${fich_erreur[@]}"; do
        count=$((count + $(grep -c "" $error_log)))
    done
    echo "Nombre de différentes erreurs dans les fichiers du $mois_var mois : $count"
}

nombre_erreurs_type() {
    types=""
    for error_log in "${fich_erreur[@]}"; do
        types="$types $(grep "" $error_log | awk '{print $6}')"
    done
    types=$(echo "$types" | sort | uniq)
    count=$(echo "$types" | wc -l)
    echo "Nombre de différents types d'erreurs dans les fichiers error_$mois_var.log: $count"
}

erreur_par_ip() {
    IP=$1
    errors=""
    for error_log in "${fich_erreur[@]}"; do
        errors="$errors $(grep "" $error_log | grep "$IP" | awk '{print $1 " " $2 " " $3 " " $5 " " $6 " " $7}')"
    done
    if [ -z "$errors" ]; then
        echo "Pas d'erreur trouvé pour l'adresse ip"
        return
    fi
    echo "$errors"
}

erreur_par_pid() {
    PID=$1
    errors=""
    for error_log in "${fich_erreur[@]}"; do
        errors="$errors $(grep "" $error_log | grep "$PID" | awk '{print $1 " " $2 " " $3 " " $5 " " $6 " " $7}')"
    done
    if [ -z "$errors" ]; then
        echo "Pas d'erreur trouvé pour le PID"
        return
    fi

    echo "$errors"
}

erreur_par_type() {
    type=$1
    errors=""
    for error_log in "${fich_erreur[@]}"; do
        errors="$errors $(grep "" $error_log | grep "$type" | awk '{print $1 " " $2 " " $3 " " $5 " " $6 " " $7}')"
    done

    if [ -z "$errors" ]; then
        echo "Pas d'erreur trouvé pour ce type"
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
