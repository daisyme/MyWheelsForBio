import sys, os

#python mummerFloater.py name 0(1i rate

name=sys.argv[1]
axis=int(sys.argv[2])
rate=int(sys.argv[3])

for plot in [name+'.fplot', name+'.rplot']:
	plot_file=open(plot,'r')
	m_file=open('m_'+plot,'w')
	plot_file.readline()
	for lines in plot_file:
		lines=lines.rstrip()
		line=lines.split()
		if len(line)==3:
			line[axis] = str(int(line[axis])/(rate*1.0))
			print >> m_file, line[0]+' '+line[1]+' '+line[2]
			continue
		print >> m_file, lines
	plot_file.close()
	m_file.close()

plot_file=open(name+'.gp','r')
m_file=open('m_'+name+'.gp','w')
setx=0
sety=0
for lines in plot_file:
	lines=lines.rstrip()
	line=lines.split()
	if (setx==1 and axis==0) or (sety==1 and axis==1):
		if line[0]==')':
			setx=0
			sety=0
			print >> m_file, lines
			continue
		else:
			line[1] = str(float(line[1].split(',')[0])/(rate*1.0))
			if line[0]=='""':
				print >> m_file, ' '+line[0]+' '+line[1]+' '+line[2]
				continue
			print >> m_file, ' '+line[0]+' '+line[1]+', '+line[2]
                        continue

	if len(line)>=2 and line[0] =='set':
		if line[1]=='xtics':
			setx=1
		if line[1]=='ytics':
			sety=1
		if line[1]=='xrange':
			if axis==0:
				xxrange=line[2].split(':')
				xxrange[1]=str(int(xxrange[1][:-1])/(rate*1.0))+']'
				print >> m_file, line[0]+' '+line[1]+' '+xxrange[0]+':'+xxrange[1]
				continue
		if line[1]=='yrange':
			if axis==1:
				yyrange=line[2].split(':')
                                yyrange[1]=str(int(yyrange[1][:-1])/(rate*1.0))+']'
                                print >> m_file, line[0]+' '+line[1]+' '+yyrange[0]+':'+yyrange[1]
				continue
	if len(line)>=2 and line[1]=='title':
		line[0]='"m_'+line[0][1:]
		print >> m_file, ' '.join(line)
		continue
	print >> m_file, lines
plot_file.close()
m_file.close()
	
