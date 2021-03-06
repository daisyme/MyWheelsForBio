import sys,os
import pandas as pd

agp1=pd.read_csv(sys.argv[1],sep='\t',header=None)
agp2=pd.read_csv(sys.argv[2],sep='\t',header=None)
scaffold_name=sys.argv[3]
pre=sys.argv[4]

agpM=agp1.merge(agp2, left_on=5,right_on=5)
agpS=agpM[agpM['0_x']==scaffold_name].sort_values(by=['1_y','2_y'])
agpS.to_csv(pre+'merged_agp.txt',sep='\t')
lines=agpS['0_y'].unique().tolist()

List=open(pre+'_list.txt','w')
List.write('\n'.join(str(line) for line in lines))
List.close()

