from __future__ import print_function
import sys
import re
import numpy

List = open(sys.argv[1],'r')
Npos=int(sys.argv[2])

s=0
e=0
le=0
for line in List:
	if line[0] == 'P':
		L=line.split()[1]
		s=int(L.split(":")[0])
		e=int(L.split(":")[1])
		if Npos > s:
			if Npos > e:
				le=e
				continue
			else:
				print(str(e))
				exit(0)
		else:
			print(str(le))
			exit(0)
	else:
		print(str(le))
		exit(0)
