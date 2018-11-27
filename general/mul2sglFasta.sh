#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub*,free* 
awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n } ' $1 > ${1%.*}.slg.fa
