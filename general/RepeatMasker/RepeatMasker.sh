#!/bin/bash
#$ -N RepeatMasker
#$ -m beas
#$ -q bio,adl,sf 
#$ -pe openmp 32

module load mchakrab/repeatmodeler/1.0.11
module load mchakrab/repeatmasker/4.0.7
module load ucsc-tools/jan-19-2016 

name=$1
ref=$2
dir=$3
[ -d $dir ] || mkdir $dir  
cd $dir
#BuildDatabase -name $name.repeat_modeler -engine ncbi $ref
#RepeatModeler -database $name.repeat_modeler -engine ncbi -pa 31 #-recoverDir ${name}_Modeler 
td=$(date)
year=${td##* }
outdir=$(ls -t | grep $year | head -n 1)
#mv $outdir ${name}_Modeler
lib=${name}_Modeler/consensi.fa.classified 
RepeatMasker -pa 8 -xsmall -gff -s -lib $lib -dir . -e ncbi $ref
out=$(ls *.out)
perl /data/apps/repeatmasker/4.0.7/util/buildSummary.pl -species $1 -useAbsoluteGenomeSize $out > $out.detailed
perl /data/apps/repeatmasker/4.0.7/util/rmOutToGFF3.pl $out > $out.gff3
