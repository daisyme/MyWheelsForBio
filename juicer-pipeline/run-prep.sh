#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 

module load bwa/0.7.8
ref=$1
workDir=$2
splitDir=$workDir/split
dataDir=$workDir/data
echo $1
echo $2
[ -d $splitDir ] || mkdir -p $splitDir
[ -d $dataDir ] || mkdir -p $dataDir
mv $workDir/*READ* $dataDir
[ -f $1.amb ] && [ -f $1.ann ] && [ -f $1.bwt ] && [ -f $1.pac ] && [ -f $1.sa ]|| bwa index $1
for reads in $(ls $dataDir/*READ*)
do
	qsub -N bwa_$2 ~/software/mytools/general/BWA.sh -r $ref -n 1 $reads -o $splitDir
done
#qsub -N mnd_$2 -hold_jid bwa_$2 ~/software/mytools/juicer-pipeline/run-mnd.sh $2
