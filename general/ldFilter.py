import sys,os
#python ldFilter.py filename range1 range2

ld_file=open(sys.argv[1],'r')
filter_file=open(sys.argv[2]+'T'+sys.argv[3]+sys.argv[1], 'w')
r1=int(sys.argv[2])
r2=int(sys.argv[3])

column=ld_file.readline()
print >> filter_file, column

for rows in ld_file:
	row=rows.split()
	l1=int(row[1])
	l2=int(row[2])
	if l1 < r1 or l1 > r2 or l2 < r1 or l2 > r2:
		continue
	print >> filter_file, rows

ld_file.close()
filter_file.close()
