#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub*,free* 

module load ucsc-tools/jan-19-2016
scripts="/data/users/ytao7/software/mytools/general/RepeatMasker"

name=$1
chrom_size=$2

#hgLoadOut -tabFile=$name.rmsk.tab -nosplit test $name.sorted.fa.out
#mkdir rmskClass
#sort -k12,12 $name.rmsk.tab | splitFileByColumn -ending=tab -col=12 -tab stdin rmskClass
for T in SINE LINE LTR DNA Simple Low_complexity Satellite Unknown
do
perl $scripts/toBed6+10.pl rmskClass/${T}*.tab | sort -k1,1 -k2,2n > $name.rmsk.${T}.bed
/data/apps/user_contributed_software/ytao7/kentUtils/bin/linux.x86_64/bedToBigBed -tab -type=bed6+10 -as=$scripts/rmsk16.as $name.rmsk.${T}.bed $chrom_size $name.rmsk.${T}.bb
done
