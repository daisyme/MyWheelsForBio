#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 
#$ -hold_jid salsa-pp

module load bedtools


OUT=$1
LABEL=$2
cd $OUT
[ -d bed ] || mkdir bed
bedtools bamtobed -i merge/$LABEL.bam > bed/$LABEL.bed
sort -k 4 bed/$LABEL.bed > tmp$LABEL && mv tmp$LABEL bed/$LABEL.bed
