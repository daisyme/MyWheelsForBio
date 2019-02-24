import sys, os
import pandas as pd

#python cutChrList.py orgin.fa chr_list.txt pre

fasta_file=sys.argv[1]
chr_list_file=sys.argv[2]
pre=sys.argv[3]
mode=sys.argv[4] #1 means stop at the first mismatch; 0 means scan all the files

ChrList=[line.strip() for line in open(chr_list_file)]
Fasta=open(fasta_file,'r')
Now = open(pre+".fasta","w") #just to make it work
Out=open("none",'w')
now=0

for lines in Fasta:
	line=lines.rstrip()
	if line =="":
		continue 
	if line[0] == '>':
		now=line[1:]
		if now in ChrList:
			print(now)
			Now.close()
			Now = open(pre+now+".fasta","w")
		else:
			if mode==1:
				exit(0) 
			Now.close()
			Now = Out
	print >> Now, line
Fasta.close()
Now.close()
Out.close()

