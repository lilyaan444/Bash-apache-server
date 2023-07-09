#!/bin/bash

if [ $# -ne 1 ]; then
  echo "veuillez saisir un répertoire en paramètre"
  exit 1
fi

if [ ! -d $1 ]; then
  echo "$1 n'est pas un répertoire valide"
  exit 1
fi

rep_base=$1
cd $rep_base

for fich in *; do
  if [ "$fich" = "access.log" ] || [[ "$fich" = error_* ]]; then
    annee=$(date -r $fich +%Y)
    mois=$(date -r $fich +%m)
    jour=$(date -r $fich +%d)

    if [ ! -d $annee ]; then
      mkdir $annee || {
        echo "Impossible de crée le répertoire $annee"
        exit 1
      }
    fi

    if [ ! -d $annee/$mois ]; then
      mkdir $annee/$mois || {
        echo "impossible de crée le répertoire $annee/$mois"
        exit 1
      }
    fi

    cp $fich $annee/$mois/${jour}_$fich || {
      echo "impossible de copier $fich dans le répertoire $annee/$mois"
      exit 1
    }

    >$fich
  fi
done
