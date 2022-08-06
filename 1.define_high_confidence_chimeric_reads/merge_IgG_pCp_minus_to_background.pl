#!/usr/bin/perl
die "perl $0 *bedpair" if(@ARGV < 1);

my $output_prefix="IgG_pCp_minus_merged";

my %cluster_read;
my %cluster;
foreach my $bedpair_file (@ARGV){
        my $prefix=$bedpair_file;
        $prefix=~s/.junction.intragene.Chimeric.bedpair//;
        open(BF,$bedpair_file) || die;
        while(my $line=<BF>){
                chomp $line;
                my @sub=split/\s+/,$line;
                $sub[6]=$prefix."#".$sub[6];

                #unique
                my $scale=10;
                my $left_start=int($sub[1]/$scale);
                my $left_end;
                if($sub[2] % $scale){ 
                        $left_end=int(($sub[2]/$scale)+1);
                }
                else{
                        $left_end=int($sub[2]/$scale);
                }
                my $right_start=int($sub[4]/$scale);
                my $right_end;
                if($sub[5] % $scale){
                        $right_end=int(($sub[5]/$scale)+1);
                }
                else{
                        $right_end=int($sub[5]/$scale);
                }

                $left_start=$scale*$left_start;
                $left_end=$scale*$left_end;
                $right_start=$scale*$right_start;
                $right_end=$scale*$right_end;

                my @pair_info=($sub[0]."\t".$left_start."\t".$left_end,$sub[3]."\t".$right_start."\t".$right_end);
                @pair_info=sort @pair_info;
                my $tmp_pair_info=join"\t",@pair_info;

                $cluster{$tmp_pair_info}++;

                #output
                $sub[1]=$left_start;
                $sub[2]=$left_end;
                $sub[4]=$right_start;
                $sub[5]=$right_end;
                my $new_line=join"\t",@sub;
                $cluster_read{$tmp_pair_info}{$new_line}=1;
        }
        close BF;
}

open(CLS,">$output_prefix.background.bed") || die;
open(RTOC,">$output_prefix.background_overlap_reads.list") || die;

my $cluster_id;
foreach my $c (keys %cluster){
        if($cluster{$c} < 0){
                next;
        }
        else{
                $cluster_id++;
                print CLS $c,"\tbackground_$cluster_id\t255\t+\t+\n";
                foreach (keys %{$cluster_read{$c}}){
                        print RTOC $c,"\tbackground_$cluster_id\t255\t+\t+\t";
                        print RTOC $_,"\n";
                }
        }
}


