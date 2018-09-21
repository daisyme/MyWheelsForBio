#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub*,free*

perl /data/users/ytao7/software/LDx.pl $1 $2 > $3.ld
