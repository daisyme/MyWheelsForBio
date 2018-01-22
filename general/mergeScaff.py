from __future__ import print_function
import sys, os
import pandas as pd

#python mergeScaff.py orgin.fa ChrName

fasta_file=sys.argv[1]
chr_name=sys.argv[2]
out_fasta_file="Merge_"+fasta_file

Fasta=open(fasta_file,'r')
Out=open(out_fasta_file,'w')

print(">"+chr_name, file=Out)
for lines in Fasta:
	line=lines.strip()
	if line =="":
		continue 
	if line[0] == '>':
		continue
	print(line, end='', file=Out)

Fasta.close()
Out.close()

