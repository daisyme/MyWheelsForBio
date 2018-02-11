#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 

pre=$1
ref=$2
FW=$3
RV=$4

qsub -N bt$pre ~/software/mytools/general/peprimer_bt2.sh $pre $ref $FW $RV
qsub -N bwa$pre ~/software/mytools/general/peprimer_bwa.sh $pre $ref $FW $RV
