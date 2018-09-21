#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub*,free*
#$ -t 1-100

# $1 in full path
module load R/3.4.1
mkdir $2/$SGE_TASK_ID -p
cd $2/$SGE_TASK_ID
Rscript ~/software/GUS-LD/myGUS-LD.R $1 $2 $SGE_TASK_ID 
#mv Rplots.pdf ../$2.pdf
#cd ../
#mv $2/* .
#rm -r $2
