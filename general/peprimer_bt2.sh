#!/bin/bash
#$ -N bowtie2-pcr
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 
#$ -pe openmp 32-64
#source /data/users/ytao7/.bashrc

module load bowtie2

pre=$1
ref=$2
FW=$3
RV=$4
[ -d bowtie2 ] || mkdir -p bowtie2
bowtie2-build -f $ref ./bowtie2/$pre
bowtie2 -x ./bowtie2/$pre -f -1 $FW -2 $RV -S ./bowtie2/${pre}_unstrict.sam
