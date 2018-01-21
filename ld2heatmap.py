import sys,os
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
#python ld2heatmap.py filename

ld=pd.read_csv(sys.argv[1],sep='\t',header=None,skiprows=1)
listPos1=ld[1].unique().tolist()
listPos2=ld[2].unique().tolist()
listPos=list(set(listPos1)|set(listPos2))
listPos.sort()
listIdx=[i for i in range(len(listPos))]
dictI2P=dict(zip(listIdx,listPos))
dictP2I=dict(zip(listPos,listIdx))
hm=[[-1 for j in range(len(listPos))] for i in range(len(listPos))]
for row in ld.itertuples():
	hm[dictP2I[row[2]]][dictP2I[row[3]]]=row[5]
	hm[dictP2I[row[3]]][dictP2I[row[2]]]=row[5]

HM=np.asfarray(hm)
#use the index then another plot on the side for locations
fig=plt.figure(figsize=(20,10))
fig.suptitle("Heatmap for LD with corresponding positions")
gs = gridspec.GridSpec(2, 2, width_ratios=[1, 1], height_ratios=[.05, .9],wspace=0,hspace=0.05)
ax1=plt.subplot(gs[2])
ax2=plt.subplot(gs[0])
sns.heatmap(HM,ax=ax1,cbar_ax=ax2,cbar_kws={"orientation": "horizontal"},yticklabels=True)
ax3=plt.subplot(gs[3])
plt.plot(listPos,listIdx)
ax3.tick_params(labelbottom=True, labelleft=False)
plt.show()
#simply plot it with locus info below
pdhm=pd.DataFrame(data=HM,index=listPos,columns=listPos)
sns.heatmap(pdhm)
plt.show()
