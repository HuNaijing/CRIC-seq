#!/usr/bin/perl
die "perl $0 pcp_rep1_interaction.sam > xxx.bedpe\n" if(@ARGV != 1);
my $contact_sam=shift;

my %unique;
my %gap_len;
open(CS,$contact_sam) || die;
while(my $frag_a=<CS>){
        if($frag_a=~/^@/){
                next;
        }
        my $frag_b=<CS>;
        my @sub_a=split/\s+/,$frag_a;
        my @sub_b=split/\s+/,$frag_b;
        my @id_info_a=split/_/,$sub_a[0];
        my @id_info_b=split/_/,$sub_b[0];
        my $sample_a=shift @id_info_a;
        my $sample_b=shift @id_info_b;
        my $strand_a=$id_info_a[2];
        my $strand_b=$id_info_b[2];

        my $real_strand_a;
        my $real_strand_b;

        if($strand_a eq "Plus"){
                $real_strand_a="+";
        }
        elsif($strand_a eq "Minus"){
                $real_strand_a="-";
        }
        else{
                die "wrong format\n";
        }
        if($strand_b eq "Plus"){
                $real_strand_b="+";
        }
        elsif($strand_b eq "Minus"){
                $real_strand_b="-";
        }
        else{
                die "wrong format\n";
        }


        if($id_info_a[0]."_".$id_info_a[1] ne $id_info_b[0]."_".$id_info_b[1]){
                die "wrong format\n";
        }
        else{#same read name
                my $chr_a=$sub_a[2];
                my $loci_a=$sub_a[3];
                my $cigar_a=$sub_a[5];
                $cigar_a=~/(\d+)M/;
                my $match_a=$1;
                my $end_a=$loci_a+$match_a-1;
                $sub_a[1] = $sub_a[1] > 255 ? $sub_a[1]-256 : $sub_a[1];

                my $chr_b=$sub_b[2];
                my $loci_b=$sub_b[3];
                my $cigar_b=$sub_b[5];
                $cigar_b=~/(\d+)M/;
                my $match_b=$1;
                my $end_b=$loci_b+$match_b-1;

                $sub_a[1]=$sub_a[1] >= 256 ? $sub_a[1] - 256 : $sub_a[1];

                if($end_a < $loci_b){
                        print $chr_a,"\t",$end_a,"\t",$end_a+1,"\t";
                        print $chr_b,"\t",$loci_b,"\t",$loci_b+1,"\t";
                        print $sample_a."_".$id_info_a[0]."_".$id_info_a[1],"\t255\t",$real_strand_a,"\t",$real_strand_b,"\n";

                }
                else{
                        print $chr_b,"\t",$end_b,"\t",$end_b+1,"\t";
                        print $chr_a,"\t",$loci_a,"\t",$loci_a+1,"\t";
                        print $sample_a."_".$id_info_a[0]."_".$id_info_a[1],"\t255\t",$real_strand_b,"\t",$real_strand_a,"\n";
                }


        }
}

#foreach (sort {$a<=>$b} keys %gap_len){
#       print STDERR $_,"\t",$gap_len{$_},"\n";
#}
