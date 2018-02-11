#! /bin/bash
#$ -N BWA
#$ -q bio,adl,abio,pub64,free64
#$ -pe openmp 32-64
#$ -m beas
#$ -ckpt blcr
#$ -R y

usage(){ echo "Usage: $0 [-r <referencefile>] [-n 1|2] <read1> <read2>" 1>&2; exit 1;}
module load bwa/0.7.8
number=1
while getopts 'r:n:' opt; do
	case $opt in
		r) 	ref="$OPTARG";;
		n) 	number="$OPTARG"
			((number==1||number==2))||usage
			;;
		*) 	usage;;
	esac
done
echo "number=$number"
echo "ref=$ref"
shift $(( OPTIND-1 ))
if [ $number -eq 1 ]
then
	bwa mem -t $CORES -M $ref $1 > $1.align2ref.sam
else
	bwa mem -t $CORES -M $ref $1 $2 >$1.align22ref.sam
fi
