#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 
#$ -pe openmp 32-64
#$ -hold_jid gdata

source /data/users/ytao7/.bashrc

nucmer --mum $1 $2 -p $3 -t $CORES
mummerplot -p $3 -f $3.delta
