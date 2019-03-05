from __future__ import print_function
import sys
import re
import numpy

Fasta = open(sys.argv[1],'r')
Ns=0
Nlen=0
stat=0
now=0
while True:
	c = Fasta.read(1)
	if not c:
		if stat == 1:
			print(":"+str(now))
		print("Done with "+str(Ns)+" Ns detected.")
		break
	if c == "N":
		now = now + 1
		Nlen = Nlen + 1
		if stat == 0:
			stat = 1
			Ns = Ns + 1
			print("Pos: "+str(now),end='')
		else:
			continue
	elif c == "\n":
		continue
	else:
		now = now + 1
		if stat == 0:
			continue
		if stat == 1:
			stat = 0
			print(":"+str(now),end='')
			print(" "+str(Nlen))
			Nlen = 0
