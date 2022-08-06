#!/usr/bin/python3
import os,sys
from collections import defaultdict

background_cluster = sys.argv[1]
background_read_in_cluster = sys.argv[2]
RBP_read_in_cluster = sys.argv[3]
RBP_read_sam_file = sys.argv[4]

outfile = open("need_remove_readID.txt","w")
outfile1 = open("removed_background_%s"%RBP_read_sam_file,"w")

cluster_set = set()
with open("%s"%background_cluster) as infile:
    lines = infile.readlines()
    for line in lines:
        sub = line.strip("\n").split("\t")
        cluster_set.add(sub[6])

control_dict = defaultdict(set)
with open("%s"%background_read_in_cluster) as infile1:
    lines1 = infile1.readlines()
    for line1 in lines1:
        sub1 = line1.strip("\n").split("\t")
        control_dict[sub1[6]].add(sub1[16])

PTB_dict = defaultdict(set)
with open("%s"%RBP_read_in_cluster) as infile2:
    lines2 = infile2.readlines()
    for line2 in lines2:
        sub2 = line2.strip("\n").split("\t")
        PTB_dict[sub2[6]].add(sub2[16])

need_remove_read = set()
for cluster in cluster_set:
    if cluster in control_dict.keys():
        if cluster in PTB_dict.keys():
            control_num = len(control_dict[cluster])
            PTB_num = len(PTB_dict[cluster])
            FC = PTB_num / control_num
            if FC < 5:
                need_remove_read = need_remove_read | PTB_dict[cluster]

print("\n".join(need_remove_read),file = outfile)

with open("%s"%RBP_read_sam_file) as infile3:
    lines3 = infile3.readlines()
    for line3 in lines3:
        sub3 = line3.split("_")
        ids = "_".join(sub3[0:3])
        if ids not in need_remove_read:
            print(line3.strip("\n"),file =outfile1)
