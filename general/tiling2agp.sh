#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 

module load enthought_python

python ~/software/mytools/general/tiling2agp.py $1
