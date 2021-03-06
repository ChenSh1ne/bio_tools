#! /usr/bin/env perl
use strict;
use warnings;

my $in="length.qassoc.adjusted";
my $out="$0.txt";

open I,"< $in";
<I>;
my %hash;
my %len;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $p=$a[-6]; # Change this to choose adjust method
    next if($p eq "NA");
    $a[1]=~/(.*)-(\d+)$/;
    my ($chr,$pos)=($1,$2);
    my $log=(log($p)/log(10))*-1;
    $hash{$chr}{$pos}{p}=$p;
    $hash{$chr}{$pos}{log}=$log;
    $hash{$chr}{$pos}{id}=$a[1];
    if(!exists $len{$chr}){
	$len{$chr}=$pos;
    }
    elsif($pos > $len{$chr}){
	$len{$chr}=$pos;
    }
}
close I;

open O,"> $out";
print O "type\tpos\tid\tp_adjust\tlog\n";
my $step=0;
my $type=1;
foreach my $chr(sort {$len{$b} <=> $len{$a}} keys %len){
    foreach my $pos(sort {$b<=>$a} keys %{$hash{$chr}}){
	my $p=$hash{$chr}{$pos}{p};
	my $log=$hash{$chr}{$pos}{log};
	my $id=$hash{$chr}{$pos}{id};
	my $new_pos=$pos+$step;
	print O "$type\t$new_pos\t$id\t$p\t$log\n";
    }
    $type*=-1;
    $step+=$len{$chr}+1000;
}
close O;
