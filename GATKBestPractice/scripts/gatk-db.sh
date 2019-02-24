#!/bin/bash
#$ -m beas
#$ -q bio,abio,abio128,adl,sf,pub*,free*,krt,krti,krt2 
#$ -ckpt restart
#$ -pe openmp 8


# when it gets stable, the top results to be ~2 cores.

GATK="/data/users/ytao7/software/gatk-4.1.0.0/gatk-package-4.1.0.0-local.jar"
module load java/1.8.0.111

ref=$1
REF=$2
sampleFile=$3
postfix=$4
i=$6
interval=$5$i
idir=$7
odir=$8
tmp=""
while read prefix
do
    tmp="$tmp -V $idir/$prefix$postfix"
done < $sampleFile

java -d64 -Xmx32g -jar $GATK GenomicsDBImport \
--genomicsdb-workspace-path $odir/${REF}_$i \
--batch-size 100 \
--reader-threads $CORES \
--overwrite-existing-genomicsdb-workspace \
-L $interval \
-R $ref \
$tmp
