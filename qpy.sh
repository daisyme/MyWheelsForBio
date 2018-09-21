#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub*,free* 

module load enthought_python
python $@
