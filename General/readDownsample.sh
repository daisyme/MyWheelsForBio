#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 

module load enthought_python

zcat $1 | python /data/users/ytao7/software/mytools/general/readDownsample.py $2 $4> $3\_$4.fq
