import sys,os

multi=open(sys.argv[1]+".gp",'w')
print >> multi, '''set terminal postscript eps enhanced color font 'Helvetica,10'
set output 'multipanel.eps'
set size 1.0, 1.1
set origin 0.0, 0.0
set label "Dot plot between different assemblies (Chr 3)" at screen 0.5, 1.05 center
set multiplot 
set grid
unset key
set key at screen 0.97,screen 0.10
set tics scale 0
unset xtics
unset ytics
set format "%.0f" 
set mouse format "%.0f" 
set mouse mouseformat "[%.0f, %.0f]"'''

R=[0,1,0,0,0,1]
Z=['dsp_0','ds1_0','ds2_0','sspp','ssp1','ssp2']
D=['24pp','24p1','24p2']
X=['3dpp','3dp1','3dp2','ssppcr','ssp1cr','ssp2cr']
Xname=['3d-dna/pp','3d-dna/p1','3d-dna/p2','SALSA/pp','SALSA/p1','SALSA/p2']
Zname=['downsample pp','downsample p1','downsample p2','no modification pp','no modification p1','no modification p2']
Y=X
link='VS'
reverse=['noreverse','reverse']

p=0
for xx in range(6):
	for yy in range(xx+1):
		name = X[xx]+link+Y[yy]
		if xx == yy:
			if xx < 3:
				name = Z[xx]+link+D[xx]
			if xx > 2:
				name = Z[xx]+link+X[xx]
			print >> multi, 'set xlabel "'+ Zname[xx] + '"'
		if xx == 5:
                	print >> multi, 'set ylabel "'+Xname[yy]+'"'# offset 4,0,0'
		print >> multi, 'set tmargin at screen '+str(0.22+(5-yy)*0.15)+'; set bmargin at screen '+ str(0.07+(5-yy)*0.15)
		print >> multi, 'set lmargin at screen '+str(0.08+(5-xx)*0.15)+'; set rmargin at screen '+ str(0.23+(5-xx)*0.15)
		if yy == 0:
			print >> multi, 'set x2label "'+Xname[xx]+'"'
		print >> multi, 'set xrange[:] '+reverse[R[xx]]
		print >> multi, 'set yrange[:] '+reverse[R[yy]]
		if os.path.exists(name+'.fplot'):
			print >> multi, 'set style line 1  lt 1 lw 2 ps 0\nset style line 2  lt 1 lc 3 lw 2 ps 0\nset style line 3  lt 2 lw 2'
			print >> multi, 'set origin '+str(xx/6.0)+', '+str(yy/6.0)
			if R[xx]+R[yy] == 1:
				print >> multi, 'plot "'+name+'.rplot" title "FWD" w lp ls 1,"'+name+'.fplot" title "REV" w lp ls 2'
			else:
				print >> multi, 'plot "'+name+'.fplot" title "FWD" w lp ls 1,"'+name+'.rplot" title "REV" w lp ls 2'
				
		print >> multi, 'unset x2label\nunset x2tics'#\nset bmargin 1'
		print >> multi, 'unset xlabel\nunset xtics'
	print >> multi, 'unset ylabel \nunset ytics'#\nset lmargin 1'
print >> multi, 'unset multiplot \npause -1'	

multi.close()
