#!/bin/bash
#$ -m beas
#$ -q krt,krti,krt2,bio,abio,abio128,adl,sf 
#$ -ckpt restart
#$ -pe openmp 2
#$ -l h_vmem=16g
#$ -l mem_free=20g


GATK="/data/users/ytao7/software/gatk-4.1.0.0/gatk-package-4.1.0.0-local.jar"
module load java/1.8.0.111

ref=$1
REF=$2
i=$3
#interval=$5$i
idir=$4
odir=$5

mkdir $odir/tmp_$i
java -d64 -Xmx16g -XX:ParallelGCThreads=1 -jar $GATK GenotypeGVCFs \
-R $ref \
-V gendb://$idir/${REF}_$i \
-O $odir/${REF}_$i.vcf \
--max-genotype-count 4
##--founder-id #once you know the founder-id
##--heterozygosity 0.005 #what should be here for cichlid?
##-L $interval \
##-O $odir/${REF}_$i.vcf.gz 

