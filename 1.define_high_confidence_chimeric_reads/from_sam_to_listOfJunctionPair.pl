#!/usr/bin/perl
die "perl $0 <Chimeric_reads.sam>\n" if(@ARGV != 1);
my $sam=shift;

open(SM,$sam) || die;
while(my $frag_a=<SM>){
        if($frag_a=~/^@/){
                next;
        }
        else{
                my $frag_b=<SM>;
                my @sub_a=split/\s+/,$frag_a;
                my @sub_b=split/\s+/,$frag_b;
                my @id_a_info=split/_/,$sub_a[0];
                my @id_b_info=split/_/,$sub_b[0];
                my $sample_a=shift @id_a_info;
                my $sample_b=shift @id_b_info;
                my $strand_a=$sub_a[1];
                my $strand_b=$sub_b[1];

                if($id_a_info[1] ne $id_a_info[1]){     #same pair
                        print $frag_a,$frag_b;
                        die "did not belong to the same pair\n";
                }

                my $chr_a=$sub_a[2];
                my ($loci_a,$end_a)=get_map_start_end($frag_a);
                $sub_a[1] = $sub_a[1] > 255 ? $sub_a[1]-256 : $sub_a[1];

                my $chr_b=$sub_b[2];
                my ($loci_b,$end_b)=get_map_start_end($frag_b);
                $sub_b[1] = $sub_b[1] > 255 ? $sub_b[1]-256 : $sub_b[1];


                if($id_a_info[0] =~ /AlignPair/){
                        next;
                }

                elsif($id_a_info[0] =~ /Part/){
                        print $sub_a[0],"\t",$sub_a[1],"\t",$chr_a,"\t",$end_a,"\t0\t";
                        print $sub_b[0],"\t",$sub_b[1],"\t",$chr_b,"\t",$loci_b,"\t1\t50\t50\n";

                }

                elsif($id_a_info[0] =~ /Chimeric/){
                        if($sub_a[1] eq "0"){
                                if($end_b > $loci_a){
                                        #print $frag_a,$frag_b;
                                        next;
                                }
                                print $sub_b[0],"\t",$sub_b[1],"\t",$chr_b,"\t",$loci_b,"\t0\t";
                                print $sub_a[0],"\t",$sub_a[1],"\t",$chr_a,"\t",$end_a,"\t1\t50\t50\n";
                        }
                        elsif($sub_a[1] eq "16"){
                                if($end_a > $loci_b){
                                        #print $frag_a,$frag_b;
                                        next;
                                }
                                print $sub_a[0],"\t",$sub_a[1],"\t",$chr_a,"\t",$loci_a,"\t0\t";
                                print $sub_b[0],"\t",$sub_b[1],"\t",$chr_b,"\t",$end_b,"\t1\t50\t50\n";
                        }
                        else{
                                print $frag_a,$frag_b;
                                die "wrong strand\n";
                        }
                }
                else{
                        print $frag_a,$frag_b;
                        die "wrong format";
                }
        }
}




sub get_map_start_end{
        my $frag=shift;
        my @sub=split/\s+/,$frag;
        my $cigar=$sub[5];
        my $chr_start=$sub[3];
        my $chr_end=$sub[3];
        while($cigar=~/(\d+)(\w)/g){
                my $tmp_len=$1;
                my $tmp_content=$2;
                if($tmp_content eq "M"){
                        $chr_end+=$tmp_len;
                }
                elsif($tmp_content eq "I"){
                }
                elsif($tmp_content eq "D"){
                        $chr_end+=$tmp_len;
                }
                elsif($tmp_content eq "S" or $tmp_content eq "H"){
                }
                elsif($tmp_content eq "N"){
                        warn "No gap exists in chimeric segments\n";
                        warn $frag;
                        die;
                }
        }
        return ($chr_start,$chr_end-1);
}
