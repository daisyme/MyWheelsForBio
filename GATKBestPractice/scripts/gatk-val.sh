#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub*,free* 
#$ -ckpt restart
#$ -l h_vmem=16g
#$ -l mem_free=20g

GATK="/data/apps/gatk/4.0.4.0/gatk-package-4.0.4.0-local.jar"
module load java/1.8.0.111

sample=$1
idir=$2
odir=$3

java -d64 -Xmx8g -jar $GATK SortSam \
-I=$idir/${sample}.bam \
-O=$odir/${sample}_sorted.bam \
--SORT_ORDER=coordinate \
--CREATE_INDEX=true

cd $odir

#Actually I should do merge here...
#java -jar $GATK MarkDuplicates \
#--TMP_DIR=tmp \
#-I=${sample}_sorted_file1.bam \
#-I=${sample}_sorted_file2.bam \
#-O=${sample}.dedup.bam \
#--METRICS_FILE=${sample}.dedup.metrics.txt \
#--REMOVE_DUPLICATES=false \
#--TAGGING_POLICY=All

java -d64 -Xmx8g -jar $GATK ValidateSamFile \
-I=${sample}_sorted.bam \
-O=${sample}.validate.txt \
--MODE=SUMMARY

