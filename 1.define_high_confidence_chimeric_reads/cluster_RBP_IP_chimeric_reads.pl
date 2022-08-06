#!/usr/bin/perl
my $list=shift;

my $resolution=10;

my %matrix;
my %matrix_frag;
open(LST,$list) || die;
while(my $line=<LST>){
        chomp $line;
        my @sub=split/\s+/,$line;
        my @id_info_a=split/_/,$sub[0];
        my @id_info_b=split/_/,$sub[5];
        my $strand_a=$id_info_a[3];
        my $strand_b=$id_info_b[3];
        my $key=$sub[2];

        my $left;
        my $right;

        if($sub[2] eq $sub[7]){ #same chr: left < right
                if($sub[3] < $sub[8]){
                        $left=$sub[3];
                        $right=$sub[8];
                }
                else{
                        $left=$sub[8];
                        $right=$sub[3];
                }
        }
        else{   #inter chr
                $left=$sub[3];
                $right=$sub[8];
        }


        my $winLeft=int($left/$resolution);
        my $winRight=int($right/$resolution);
        $key.="\t".$strand_a."\t".$winLeft."\t".$sub[7]."\t".$strand_b."\t".$winRight;
#	print $key;
#	last;
        $matrix{$key}++;


        my @read_info=split/_/,$sub[0];
        my $frag=$read_info[0]."#".$read_info[-1];
        $matrix_frag{$key}{$frag}=1;
}

foreach (keys %matrix){
        print $_,"\t",$matrix{$_},"\t";

        my @frag=keys %{$matrix_frag{$_}};
        print $#frag+1,"\n";

}
