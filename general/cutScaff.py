import sys, os
import pandas as pd

#python cutScaff.py orgin.fa chr_list.txt output.fa

fasta_file=sys.argv[1]
chr_list_file=sys.argv[2]
pre=sys.argv[3]

out_fasta_file1=pre+".fasta"
out_fasta_file2=pre+"_out.fasta"

ChrList=[line.strip() for line in open(chr_list_file)]
Fasta=open(fasta_file,'r')
In=open(out_fasta_file1,'w')
Out=open(out_fasta_file2,'w')
now=0

for lines in Fasta:
	line=lines.rstrip()
	if line =="":
		continue 
	if line[0] == '>':
		now=line[1:]
		if now in ChrList:
			Now = In
		else:
			Now = Out
	print >> Now, line
Fasta.close()
In.close()
Out.close()

