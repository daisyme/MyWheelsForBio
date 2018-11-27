#!/bin/sh
#$ -q adl,bio,abio,free*,pub*
#$ -m beas
zcat $1 | perl ~/software/mytools/juicer-pipeline/trimreads.pl - | gzip -c - > $2

