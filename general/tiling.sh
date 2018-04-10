#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 
##$ -pe openmp 32-64

#module load quickmerge
source /data/users/ytao7/.bashrc

#nucmer --mum -p $1 $2 $3 -t $CORES

show-tiling $1.delta > $1.tiling
