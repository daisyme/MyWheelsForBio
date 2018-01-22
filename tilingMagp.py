import pandas as pd
import sys, os
tiling=pd.read_csv(sys.argv[1],sep='\t',header=None)
agp=pd.read_csv(sys.argv[2],sep='\t',header=None)

