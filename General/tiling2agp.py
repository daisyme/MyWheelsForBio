import pandas as pd
import sys, os
tiling_file=sys.argv[1]
Tiling=open(tiling_file,'r')
Agp=open(tiling_file+'.agp','w')

lines = Tiling.readline()
scaffold=lines.split()[0][1:]

for lines in Tiling:
        if lines[0] == '>':
                scaffold=lines.split()[0][1:]
                continue
        line=lines.split()
        print >> Agp, scaffold+'\t'+line[0]+'\t'+line[1]+'\t'+'1'+'\t'+'W'+'\t'+line[7]+'\t'+'1'+'\t'+line[3]+'\t'+line[6]

Tiling.close()
Agp.close()

