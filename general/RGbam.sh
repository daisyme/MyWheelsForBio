#!/bin/bash
#$ -N RG 
#$ -q bio,adl,sf,pub64,krt,krti,free88i,free16i
#$ -pe make 8 
#$ -R y

module load bwa/0.7.8
module load samtools/1.3
module load bcftools/1.3
module load enthought_python/7.3.2
module load gatk/2.4-7
module load picard-tools/1.87
module load java/1.7
module load tophat/2.1.0
module load bowtie2/2.2.7

samplename=$1
odir=$2
samtools sort $odir/$samplename.bam -o $odir/$samplename.sort.bam
java -Xmx20g -jar /data/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I=$odir/$samplename.sort.bam O=$odir/$samplename.RG.bam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=$samplename RGSM=$samplename VALIDATION_STRINGENCY=LENIENT
