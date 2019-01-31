#!/bin/bash
#$ -m beas
#$ -q bio,abio,abio128,adl,sf,pub*,free* 
#$ -ckpt restart
#$ -pe openmp 2
#$ -l h_vmem=16g
#$ -l mem_free=20g

GATK="/data/users/ytao7/software/gatk-4.0.12.0/gatk-package-4.0.12.0-local.jar"
module load java/1.8.0.111

ref=$1
REF=$2
i=$3
chrFmt=$4
batch=$5
idir=$6
odir=$7

chr=$chrFmt$i
tmp=TMP-$chr
[ -d $odir/$tmp ] || mkdir $odir/$tmp

len=$(grep $chr$'\t' $ref.fai | cut -f2)
interval=$chr:$(($batch*($SGE_TASK_ID-1)+1))
#( [ $len -lt $(($batch*$SGE_TASK_ID)) ]  interval=$interval-$len ) || interval=$interval-$(($batch*$SGE_TASK_ID))

if [ $len -lt $(($batch*$SGE_TASK_ID)) ];then
    interval=$interval-$len
else
    interval=$interval-$(($batch*$SGE_TASK_ID))
fi

java -d64 -Xmx16g -jar $GATK GenotypeGVCFs \
-R $ref \
-V gendb://$idir/${REF}_$i \
-O $odir/$tmp/${REF}_$interval.vcf \
-L $interval
