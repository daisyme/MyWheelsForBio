#!/bin/bash
#$ -N RepeatMasker
#$ -m beas
#$ -q bio,adl,sf 

module load mchakrab/repeatmodeler/1.0.11
module load mchakrab/repeatmasker/4.0.7
module load ucsc-tools/jan-19-2016

ref=$1
name=$2
hgLoadOut -tabFile=$ref.rmsk.tab -nosplit test $ref.fasta.out
mkdir rmskClass
sort -k12,12 $ref.rmsk.tab | splitFileByColumn -ending=tab -col=12 -tab stdin rmskClass
for T in SINE LINE LTR DNA Simple Low_complexity Satellite Unknown
do
 perl toBed6+10.pl rmskClass/${T}*.tab | sort -k1,1 -k2,2n > rmskClass/rmsk.${T}.bed
done

for T in SINE LINE LTR DNA Simple Low_complexity Satellite Unknown
do
  bedToBigBed -tab -type=bed6+10 -as=rmsk16.as rmskClass/rmsk.${T}.bed $name.chrom.sizes rmskClass/$ref.rmsk.${T}.bb
done
