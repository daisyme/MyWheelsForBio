import sys,os
import pandas as pd

agp1=pd.read_csv(sys.argv[1],sep='\t',header=None)
agp2=pd.read_csv(sys.argv[2],sep='\t',header=None)
scaffold_name=sys.argv[3]
pre=sys.argv[4]
threshold=int(sys.argv[5])

agpM=agp1.merge(agp2, left_on=5,right_on=5)
agpS=agpM[(agpM['0_x']==scaffold_name) & (agpM['7_x'].astype('int') > threshold) & (agpM['7_y'].astype('int') > threshold)].sort_values(by=['1_y','2_y'])
agpS.to_csv(pre+'merged_agp_t'+sys.argv[5]+'.txt',sep='\t')
lines=agpS['0_y'].unique().tolist()

List=open(pre+'_list_t'+sys.argv[5]+'.txt','w')
List.write('\n'.join(str(line) for line in lines))
List.close()

