import sys, os
import re
import pandas as pd
psl=open(sys.argv[1],'r')
cds=open(sys.argv[2],'r')
out=open(sys.argv[3],'w')
#chr_NC=open("chr_NC_gi",'r')
#chr_NC.readline()
#dictNC={x.split()[1]: "chr"+x.split()[0] for x in chr_NC}
#chr_NC.close()
#unsort=pd.read_csv(sys.argv[4],sep='\s+',index_col=0)
#dictCS=unsort.idxmax(axis=1).to_dict()
#dictSC={v: "chr"+k for k, v in dictCS.iteritems()}

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

dictGene={}
for match in psl:
	info=match.split()
	strand=info[8]
	gene=info[9]
	#cname="chrUn"
	#if info[13][45:] in dictSC:
	#	cname=dictSC[info[13][45:]]
        cname=info[13][45:] #TODO:change it to be split by '_'
	cstart=info[15]
	cend=info[16]
	dictGene[gene]=">"+gene+" "+cname+" "+cstart+" "+cend+" "+strand
psl.close()
seq=""
for record in cds:
	info=record.split()
	if info[0][0]==">":
		if gene in dictGene:
			if seq!="":
				print>>out, translate(seq)
		seq=""
		gene=info[0][1:]
		gname=info[1][5:]
		if gene in dictGene:
			print>>out, dictGene[gene]+" "+gname
		continue
	seq += info[0]
if gene in dictGene:
	print>>out, translate(seq)
cds.close()
out.close()
