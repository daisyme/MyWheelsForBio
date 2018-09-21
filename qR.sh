#!/bin/bash
#$ -m beas
#$ -l mem_size=512
#$ -q abio,bio,adl,sf,pub*,free* 

module load R/3.4.1
Rscript $@
