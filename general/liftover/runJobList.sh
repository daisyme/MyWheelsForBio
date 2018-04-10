#!/bin/bash
#$ -N blatter
#$ -q bio,adl,pub64,pub8i

i=0
while read line
do
	((i = i + 1))	
	qsub -N blatL$i $line
done <$1

