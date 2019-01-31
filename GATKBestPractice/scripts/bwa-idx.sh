#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub*,free* 
#$ -ckpt restart

module load bwa/0.7.17-5g
bwa index $1
