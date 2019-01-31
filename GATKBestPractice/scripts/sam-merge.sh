#!/bin/bash
#$ -m beas
#$ -q bio,abio,adl,sf,pub*,free* 

module load samtools

samplename=$1
odir=$2
cd $odir
samtools merge ${samplename}.tmp.bam *$samplename.bam
mv ${samplename}.tmp.bam $samplename.bam
