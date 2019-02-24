chrFmt="M_zebra_hic_scaffold_"
ref="DC.O.sm.fasta"
REF="DC"
DBdir=db_$REF
VCFdir=vcf_$REF
for i in {1..22}; do total=$(grep $chrFmt$i$'\t' $ref.fai | cut -f2);now=$total;tail gt-$i-*.e* -n 2 | grep -q "done" || now=$(grep $chrFmt gt-$i-*.e* | tail -n 1| cut -f6 -d" " | cut -f2 -d":"); tail gt-$i-*.e* -n 2 | grep -q "done" || qsub -N gtsp-$i-DC scripts/gatk-gt-parallelsp.sh $ref $REF $i $chrFmt $DBdir $VCFdir $(python getClosestNpos.py N_$i.list $now); echo $i": "$(($now*100/$total))"% ("$now"/"$total")"; done
