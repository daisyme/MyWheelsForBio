#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub*,free* 
awk '{ if ($0 !~ /^>/) $0=toupper($0); print $0 }' $1 > ${1%.*}.unmasked.fasta
