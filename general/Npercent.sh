#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64

fasta=$1

totalLength=$(grep -v ">" $fasta | wc | awk '{print $3-$1}')
numN=$(grep -v ">" $fasta | grep -o "N" | wc -l)
numF=$(grep ">" $fasta | wc -l)

echo "totalLength is "$totalLength", number of N is "$numN", fragment number is "$numF > ${2}.countN
