#remove background form RBP IP (+pCp) CRIC-seq chimeric reads
perl from_sam_to_bedOfJunctionPair.pl IgG_pCp_minus_merged.Chimeric.sam > IgG_pCp_minus_merged.Chimeric.bedpair
perl from_sam_to_bedOfJunctionPair.pl RBP_merged.Chimeric.sam > RBP_merged.Chimeric.bedpair

perl merge_IgG_pCp_minus_to_background.pl IgG_pCp_minus_merged.Chimeric.bedpair

bedtools pairtopair -a IgG_pCp_minus_merged.background.bed -b IgG_pCp_minus_merged.Chimeric.bedpair -is -rdn > IgG_pCp_minus_merged.in_background.list
bedtools pairtopair -a IgG_pCp_minus_merged.background.bed -b RBP_merged.Chimeric.bedpair -is -rdn > RBP_merged.in_background.list

python remove_background_from_RBP_IP_chimeric_reads.py IgG_pCp_minus_merged.background.bed IgG_pCp_minus_merged.in_background.list RBP_merged.in_background.list RBP_merged.Chimeric.sam

#find high confidence RBP IP (+pCp) CRIC-seq chimeric reads
perl from_sam_to_listOfJunctionPair.pl removed_background_RBP_merged.Chimeric.sam > removed_background_RBP_merged.Chimeric.list
perl cluster_RBP_IP_chimeric_reads.pl removed_background_RBP_merged.Chimeric.list > removed_background_RBP_merged.Chimeric.cluster
python make_RBP_IP_cluster_bedpair.py removed_background_RBP_merged.Chimeric.cluster read_count_cutoff
