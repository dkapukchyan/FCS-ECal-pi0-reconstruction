#!/usr/bin/perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

my $folder="$Bin";
while( chop($folder) ne "/" ){ }
print "Working folder = ${folder}\n";
print "Please write down the run number:\n";
my $run =<STDIN>;
chomp($run);
my $day = substr($run,2,3);
my $yy = substr($run,0,2);
my $year = $yy+1999;   #quick way to get year from run number
print "run number = $run\n";
print "year = $year\n";

my $mudstroot="/star/data1*/reco/production_pp500_2022/ReversedFullField/pp500_22_DEV_fcs/$year/$day/$run/st_fwd*.MuDst.root";
print "MuDst files location =  $mudstroot\n";

my $pi0root="$folder/run22root/$run";
print "Checking/Creating $pi0root\n";
if (not -d "$pi0root") {system("/bin/mkdir $pi0root") == 0 or die "Unable to make folder '$pi0root': $!";}

my $log="$folder/submitScheduler/log/";
if (not -d "$log") {system("/bin/mkdir $log") == 0 or die "Unable to make folder '$log': $!"; }

opendir my $dh, $pi0root or die "Unable to open directory '$pi0root': $!";
my @files = readdir $dh;
if( scalar(@files)>2 ){
    print "Remove files in $pi0root (Y/n):";
    my $input = <STDIN>; chomp $input;
    if( $input eq "Y" ){
	foreach my $file (@files){
	    if( $file =~ m/StFcsPi0invariantmass${run}_\w*.root/ ){
		#print "$pi0root/$file\n";
		system("/bin/rm $pi0root/$file") == 0 or die "Unable to remove file in '$file': $!";
	    }
	}
    }
    else{ print "Keeping files in $pi0root\n"; }
}
closedir $dh;

print "Creating filelist\n";
my $filelist="$folder/submitScheduler/$run"."eventroot.list";
if (-f $filelist) { system("/bin/rm $filelist") == 0 or die "Unable to remove file in '$filelist': $!"; }
system("ls $mudstroot > $filelist") == 0 or die "Unable to create file list '$filelist': $!";

print "Submit job (Y/n):";
my $submit = <STDIN>; chomp($submit);
if( $submit eq "Y" ){
    system("star-submit-template -template $folder/submitScheduler/submitScheduler_dataevent_run22.xml -entities folder=$folder,runnumber=$run")==0 or die "Unable to submit job to STAR scheduler: $!";
}

