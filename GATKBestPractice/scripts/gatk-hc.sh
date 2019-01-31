#!/bin/bash
#$ -m beas
#$ -pe openmp 4
#$ -q bio,abio,abio128,adl,sf,pub*,free* 
#$ -ckpt restart
#$ -l mem_size=10


# when it gets stable, the top results to be ~2 cores.

GATK="/data/apps/gatk/4.0.4.0/gatk-package-4.0.4.0-local.jar"
module load java/1.8.0.111

sample=$1
ref=$2
idir=$3
odir=$4
scaf=$5$6
i=$6
mode=$7

[ $mode == "lc" ] && \
echo "low coverage mode" && \
java -d64 -Xmx5g -Xms5g -jar $GATK HaplotypeCaller \
-R $ref \
-I $idir/${sample}_sorted.bam \
--emit-ref-confidence GVCF \
-O $odir/$sample.$i.raw.g.vcf \
--min-pruning 1 \
--min-dangling-branch-length 1 \
-L $scaf \
--native-pair-hmm-threads ${CORES:-1}

[ $mode == "lc" ] || \
java -d64 -Xmx5g -Xms5g -jar $GATK HaplotypeCaller \
-R $ref \
-I $idir/${sample}_sorted.bam \
--emit-ref-confidence GVCF \
-O $odir/$sample.$i.raw.g.vcf \
-L $scaf \
--native-pair-hmm-threads ${CORES:-1} || \
echo "Normal mode" 
