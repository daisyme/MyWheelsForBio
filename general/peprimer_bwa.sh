#!/bin/bash
#$ -N bwa-pcr
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 
##$ -pe openmp 32-64
#source /data/users/ytao7/.bashrc

module load bwa

pre=$1
ref=$2
FW=$3
RV=$4
[ -d bwa ] || mkdir -p bwa
bwa index $ref
bwa aln -n 1 -t $CORES  $ref $FW > ./bwa/${pre}_aln_sa1.sai
bwa aln -n 1 -t $CORES  $ref $RV > ./bwa/${pre}_aln_sa2.sai
bwa sampe $ref ./bwa/${pre}_aln_sa1.sai ./bwa/${pre}_aln_sa2.sai $FW $RV > ./bwa/${pre}_aln-pe.sam
