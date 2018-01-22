import sys,os
import pandas as pd

agp1=pd.read_csv(sys.argv[1],sep='\t',header=None)
agp2=pd.read_csv(sys.argv[2],sep='\t',header=None)

