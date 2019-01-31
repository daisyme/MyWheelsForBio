#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 

module load enthought_python

REF=$1
fai=$REF.fai
OUT=$2
LABEL=$3
bed=$OUT/bed/$LABEL.bed
enzyme=$4
scaffold=$OUT/out
modify=$5
echo "BED:"$bed
echo "REF:"$ref
python /data/users/ytao7/software/SALSA/run_pipeline.py -a $REF -l $fai -b $bed -e $enzyme -o $scaffold -m $modify

