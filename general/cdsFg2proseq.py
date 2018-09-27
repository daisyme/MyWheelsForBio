import sys, os
import re
import pandas as pd
cfg=open(sys.argv[1],'r')
out=open(sys.argv[2],'w')
Dchr=open("chr2acc",'r')
Dchr.readline()
acc2chr={x.split()[1]: x.split()[0] for x in Dchr}
Dchr.close()

bases = ['t', 'c', 'a', 'g']
codons = [a+b+c for a in bases for b in bases for c in bases]
amino_acids = 'FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
codon_table = dict(zip(codons, amino_acids))

def translate(seq):
    seq = seq.lower().replace('\n', '').replace(' ', '')
    peptide = ''
    for i in xrange(0, len(seq), 3):
        codon = seq[i: i+3]
        amino_acid = codon_table.get(codon, '*')
        if amino_acid != '*':
            peptide += amino_acid
        else:
            break
    return peptide

seq=""
acc=""
for ori in cfg:
	info=ori.split(" [")
	if info[0][0]==">":
		pro=translate(seq)
		if len(pro)>=20 and acc in acc2chr:
			print>>out, ">"+ProId+" "+Chr+" "+str(Loc[0])+" "+str(Loc[-1])+" "+Strain
			print>>out, pro
		elif acc in acc2chr:
			print ">"+ProId+" "+Chr+" "+str(Loc[0])+" "+str(Loc[-1])+" "+Strain
		seq=""
		acc=info[0].split("|")[1][0:11]
		if acc in acc2chr:
			Chr=acc2chr[acc]
			ProId=info[0].split("cds_")[1]
			Loc=re.findall("\d+",info[-2])
			#print info
			#print Loc
			if "complement" in info[-2]:
				Strain='-'
			else:
				Strain='+'
		continue
	seq += info[0]
if seq!="" and acc in acc2chr:
	print>>out, ">"+ProId+" "+Chr+" "+str(Loc[0])+" "+str(Loc[-1])+" "+Strain
	print>>out, translate(seq)
cfg.close()
out.close()
