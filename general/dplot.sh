#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,abio,pub64,free64,pub8i,free32i 
#$ -pe openmp 8

source /data/users/ytao7/.bashrc

#nucmer --mum $1 $2 -p $3 -t $CORES
mummerplot --layout -p $3 $3.delta
