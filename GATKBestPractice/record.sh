#!/bin/bash
#$ -N record 
#$ -q bio,adl,sf 

## get names.txt in each folder

#while read -r line
#do 
#info=($line)
#python nametable.py ${info[0]}-Statistics/ ${info[1]}.txt
#done < run2library.txt

## get all names

#for folders in $(ls -d 4R*Statistics)
#do
#       cat $folders/names.txt >> names.all.txt
#done

## get all sample names

module load samtools

sort -k2 names.all.txt > names.sorted.txt
cut -f2 names.sorted.txt | uniq > names.sample.txt

ref="/share/adl/ytao7/summer/3d-dna/freeze/P.Leucopus.fa" # absolute path is usually welcome 
[ -f ${ref/fasta/dict} ] || qsub -N genDict$REF scripts/genDict.sh $ref ${ref/fasta/dict}
REF="P.leu" # a short name for the reference species
chrFmt="peromyscus_assembly_polished_v1_hic_scaffold_" # the format of chromosome name in your ref, e.g. "chr" for "chr7"
chrNum=24 # the total number of chromosomes
nameFile="names.sorted.txt" # the file containing the map between samplename and readfile
sampleFile="names.sample.txt" # the file with all the samplenames
batch=1000000 # the interval size for genotypeGVCFs in parallel

# for test pipeline only
#head $sampleFile -n 1 > "names.test.txt"
#sampleFile="names.test.txt"
#chrNum=2

# make the directory structure
BAMdir=bam-$REF # bam files
RAWdir=$BAMdir
GVCFdir=gvcf-$REF # genotypecaller results
DBdir=db-$REF # GenomicsDBImport
#CBdir=cb-$REF  # CombineGVCFs, an old fashioned way to combine gvcf
VCFdir=vcf-$REF
[ -d $RAWdir ] || mkdir $RAWdir
[ -d $BAMdir ] || mkdir $BAMdir
[ -d $GVCFdir ] || mkdir $GVCFdir
[ -d $DBdir ] || mkdir $DBdir
#[ -d $CBdir ] || mkdir $CBdir
[ -d $VCFdir ] || mkdir $VCFdir

[ -f ${ref/fasta/dict} ] && [ -f ${ref/fa/dict} ] || qsub -N genDict$REF scripts/genDict.sh $ref ${ref/fasta/dict}
[ -f $ref.ann ] || qsub -N idx$REF scripts/bwa-idx.sh $ref
last=$(head -n 1 $nameFile |cut -f2)
while read -r line
do
    info=$line
    samplename=${info[1]}
    filename=${info[0]}
    sampledir=${filename%-P*}
    [ -f $RAWdir/$filename-$samplename.bam ] # || qsub -N bwa$samplename -hold_jid idx$REF scripts/bwa-mem.sh $samplename $filename $ref $sampledir $BAMdir
    while [ $(qstat -u $USER|grep bwa |wc -l) -gt 100 ]
    do
    sleep 200
    done
    [ $samplename == $last ] || [ -f $RAWdir/$last.bam ] || qsub -N merge$last -hold_jid bwa$last scripts/sam-merge.sh $last $RAWdir
    last=$samplename
done < $nameFile
[ -f $RAWdir/$last.bam ] || qsub -N merge$last -hold_jid bwa$last scripts/sam-merge.sh $last $RAWdir

# to check if bam files are done correctly
#samtools quickcheck -v $BAMdir/*.bam > bad_bams.fofn
#for file in $(cat bad_bams.fofn) ; do rm $file; done

[ -f ${ref/fasta/dict} ] || qsub -N genDict$REF scripts/genDict.sh $ref ${ref/fasta/dict}
[ -f $ref.fai ] || samtools faidx $ref

while read -r sample
do              
    [ -f $BAMdir/${sample}_sorted.bam ] || \
    qsub -N val$sample -hold_jid merge$sample,qs$sample,genDict$REF scripts/validate.sh $sample $RAWdir $BAMdir
    for i in $(seq 1 $chrNum)
    do
       [ -f $GVCFdir/$sample.$i.raw.g.vcf.idx ] || qsub -N gvcf.$i -hold_jid val$sample scripts/gatk-hc.sh $sample $ref $BAMdir $GVCFdir $chrFmt $i lc
    done
    while [ $(qstat -u $USER|grep -E "gvcf|val"|wc -l) -gt 100 ]
    do
    sleep 200
    done
done < $sampleFile

for i in $(seq 1 $chrNum)
do
    qsub -N db-$i-$REF -hold_jid gvcf.$i scripts/gatk-db.sh $ref $REF $sampleFile "-RG.$i.raw.g.vcf" $chrFmt $i $GVCFdir $DBdir
## I also tried run combineGVCFs, it turned out to be slower than GenomicsDBImport
#    qsub -N cb-$i-$REF -hold_jid gvcf.$i scripts/gatk-combineGVCFs.sh $ref $REF $sampleFile "-RG.$i.raw.g.vcf" $chrFmt $i $GVCFdir $CBdir
    qsub -N gt-$i-$REF -hold_jid db-$i-$REF scripts/gatk-gt.sh $ref $REF $i $DBdir $VCFdir

## To run it in parallel
#    len=$(grep $chrFmt$i$'\t' $ref.fai | cut -f2)
#    qsub -N gt-$i-$REF -hold_jid db-$i-$REF -t 1-$((($len+$batch-1)/$batch)) scripts/gatk-gt-parallel.sh $ref $REF $i $chrFmt $batch $DBdir $VCFdir

# The file name format for vcf is fixed-written in gatk-gt
    vcf=${REF}_$i.vcf.gz
    qsub -N filter-$i-$REF -hold_jid gt-$i-$REF scripts/gatk-filter.sh $ref $vcf $VCFdir $VCFdir
done
