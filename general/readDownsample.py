from __future__ import print_function
import sys, os
mod = int(sys.argv[1])
record_number = int(sys.argv[2])
while True:
	line1 = sys.stdin.readline()
	if not line1:
		break
	line2 = sys.stdin.readline()
	line3 = sys.stdin.readline()
	line4 = sys.stdin.readline()
	now = record_number % mod
	if  now == 0:
		print(line1, end='')
		print(line2, end='')
		print(line3, end='')
		print(line4, end='')
	record_number += 1
