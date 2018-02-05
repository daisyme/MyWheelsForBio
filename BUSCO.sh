#!/bin/bash
#$ -N busco
#$ -m beas
#$ -q adl,abio,pub8i,bio
#$ -pe openmp 32-64

module load enthought_python
module load blast
#module load augustus
export PATH=$PATH:/data/apps/user_contributed_software/ytao7/augustus-3.3/bin:/data/apps/user_contributed_software/ytao7/augustus-3.3/scripts
export AUGUSTUS_CONFIG_PATH=/data/apps/user_contributed_software/ytao7/augustus-3.3/config/
module load gcc/6.4.0
module load hmmer
module load boost/1.62.0
module load bamtools

genome_name=$1
assembly_fasta=$2

python /data/users/ytao7/software/buscoV3/scripts/run_BUSCO.py -o $genome_name -i $assembly_fasta -l /data/users/ytao7/software/buscoV3/mammalia_odb9 -m geno -c $CORES -r
