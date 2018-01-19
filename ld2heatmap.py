import sys,os
import pandas as pd
import numpy as np
import seaborn as sb
import matplotlib.pyplot as plt
#python ld2heatmap.py filename

ld=pd.read_csv(sys.argv[1],sep='\t',header=None)
listPos1=ld[1].unique().tolist()
listPos2=ld[2].unique().tolist()
listPos=list(set(listPos1)|set(listPos2))
listPos.sort()
listIdx=[i for i in range(len(listPos))]
dictI2P=dict(zip(listIdx,listPos))
dictP2I=dict(zip(listPos,listIdx))
hm=[[0 for j in range(len(listPos))] for i in range(len(listPos))]
for row in ld.itertuples():
	hm[dictP2I[row[2]]][dictP2I[row[3]]]=row[5]
	hm[dictP2I[row[3]]][dictP2I[row[2]]]=row[5]

HM=np.asfarray(hm)
sb.set()
ax=sb.heatmap(HM)
plt.show()
