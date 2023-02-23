#!/usr/bin/python3
import os,sys

filename = sys.argv[1]
read_cutoff = int(sys.argv[2])
outfile = open("%s.%s.bedpair"%(filename,str(read_cutoff)),"w")

strand_dict = {"Plus":"+","Minus":"-"}
with open("%s"%filename) as infile:
	lines = infile.readlines()
	for line in lines:
		sub = line.strip("\n").split("\t")
		if int(sub[6]) >= read_cutoff:
			new_line = "\t".join([sub[0],str(int(sub[2])*10),str(int(sub[2])*10+10),sub[3],str(int(sub[5])*10),str(int(sub[5])*10+10),"cluster",sub[6],strand_dict[sub[1]],strand_dict[sub[4]]])
			print(new_line,file=outfile)
infile.close()
outfile.close()
