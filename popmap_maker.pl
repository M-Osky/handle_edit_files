#!/usr/bin/perl
use strict;
use warnings;

#popmap_maker.pl by M'Ósky

my $version = "popmap_maker_v2.01pl";

#create a popmap for various programs from filenames.
# check the help information: popmap_maker.pl --help (or any other usual help flag)



#######################################################################################################################################################################
#######################################################################################################################################################################
## 	  -  	Change log - version 2.01 - 19/05/2020
##  	  Just changed the default mode to alphanumeric, as it works fine with all our samples. Fixed help information
## 	  -  -  -  -  -  -  -  --  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
## 	  -  	Change log - version 2 - 15/10/2019
##  	  Improvements to work from command line. Easier parameters. More options.
## 	  -  -  -  -  -  -  -  --  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
## 	  -  	Change log - version 1.3 - 09/11/2018
##  	  Now you can pass a directory name as argument, it will analyse everything in it
##  	  if you do not pass a directory name, it will analyse the sample names from the files at the working directory
##  	  As usual, if the argument is "help", "--h", or similar it will output the help lines.
##  	  Also now the outputs are sorted
## 	  -  -  -  -  -  -  -  --  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
## 	  -  	Change log - version 1.2 - 07/08/2018
##  	  I decided that it will be usefull to output a list of the populations
## 	  -  -  -  -  -  -  -  --  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
## 	  -  	Change log - version 1.1 - 06/08/2018
##  	  A bug was detected, when there was files with the same sample name (like bam and bai files) it was storing each name twice.
##  	  Now it uses %hashes in despite of @arrays, this way it will not store repeated values.
##  	  Also now it saves the popmap file in the working directory, not in the subdirectory with the samples
#######################################################################################################################################################################
#######################################################################################################################################################################




########DEFAULT PARAMETER VALUES

#DO NOT CHANGE THIS VARIABLE
my $default = "No default";
#my $default = "No default";

my $sep = "\t";
#my $sep = " ";

my $first = '.';
#my $first = '\.';

my $last = $default;
#my $last = '.';

my $dir = $default;
#my $dir = '.';

my $filter = $default;
#my $filter = "*.ba*";
#my $filter = $default;

my $poplength=$default;
#my $poplength=2;

my $popsep=$default;
#my $poplimit=$default;
#my $poplimit="_";

my $popmap = "popmap";
#my $popmap = "popmap";

my $sampini=0;
#my $sampini=0;
my $popini=0;
#my $popini=0;
my $sampfin=0;
#my $sampfin=0;
my $popfin=0;
#my $popfin=0;

my $alphanum=1;
#my $alphanum=0;

#4 8 15 16 23 42

my %arguments = map { $_ => 1 } @ARGV;
if(exists($arguments{"help"}) || exists($arguments{"--help"}) || exists($arguments{"-help"}) || exists($arguments{"h"}) || exists($arguments{"-h"}) || exists($arguments{"--h"})) {
	die "\n\n\t   $version   Help Information\n\t-------------------------------------------------\n
\tUse this program to generate a popmap file for multiple softwares (Stacks, PGDSpider) from the file names in a directory.
\tpopmap will be one sample per row, tab separated: sample1    pop1   -->    (samp1\\tpop1\\nsamp2\\tpop1)
\tWill skip files with identical names. It will output also a file list, sample list and population list.\n\n
\tParameters:\n
\t--dir          path to the directory including the files (local working directory by default).\n
\t--filter       only files that match a specific regex regular expresion string, use \"\'\" (like \'.*\\.ba.*\'). $default.\n
\t--popmap       file name or path for the popmap file produced. Default: $popmap.\n
\t--colsep       column separator for the popmap. By default tab-separated file \"\\t\".\n
\t--first        symbol that marks the end of the file name to read as sample name. By default will read until the FIRST \"$first\"
\t--last         Alternatively: Read names from file names until the LAST time a especific symbol appears. $last\n
\tBy default popmap_maker will identify populations from the alphabetical part of the sample name, until the first number.
\t               Example: \"SKA4\" --> sample \"SKA4\" from population \"SKA\".\n\n
\tAlternatives:\n
\tNumber of characters at the beginning of the sample name that belong to the population code:
\t--poplength    [int] Example: \'--poplength 8\'    \"AtlantisSept15\" -> sample \"AtlantisSept15\" from population \"Atlantis\";\n
\tUse a character/symbol separating population and sample names: \"-\", \"_\", or \".\":
\t--popsep       Example: \'--popsep \'_\'\'    \"Caca_Monday16\" -> sample \"Caca_Monday16\" from populationn \"Caca\";\n
\tAlternatively identify population and sample by position (set all these parameters):
\t--sampini      [int] in which character begins the sample ID
\t--sampfin      [int] in which character ends the sample ID
\t--popini       [int] in which character begins the population ID
\t--popfin       [int] in which character ends the population ID
\tExample: \'--popini 12 --popfin 20 --sampini 1 --sampfin 7\'    \"Indiv23_rawLemuria42\" -> sample \"Indiv23\" from populationn \"Lemuria42\";\n\n
\t In most of the cases if your file names are correctly formated you should be able to run this correctly by just typing the program name:\n\n\t\tpopmap_maker.pl \n\n\n"
}


################ PASSING ARGUMENTS


use Getopt::Long;

GetOptions( "dir=s" => \$dir,    #   --dir
            "colsep=s" => \$sep,      #   --colsep
            "first=s" => \$first,      #   --first
            "last=s" => \$last,      #   --last
            "poplength=i" => \$poplength,      #   --poplength
            "filter=s" => \$filter,      #   --filter
            "popsep=s" => \$popsep,      #   --popsep
            "sampini=i" => \$sampini,      #   --sampini
            "sampfin=i" => \$sampfin,      #   --sampfin
            "popini=i" => \$popini,      #   --popini
            "popfin=i" => \$popfin );   #   --popfin


if ($popsep eq $first && $last eq $default) { die "\n\n\tERROR!\n$version was set to read file names until the first \"$first\", but also to use \"$popsep\" as a population separator.\nI'm confused, may be you wanted to use --last? I don't know what to do, it's dark out there...\nCheck the help information: popmap_maker.pl help\n\n"}
if ($popfin > 0 && $popini <=  $popfin || $sampfin > 0 && $popini >= $popfin) { print "\n\n\tERROR!\n$version was set read population and sample names by position in filename, population name beginning should be lower than population ending position...\nBut it is not. --popini $popini --popfin $popfin   I'll proceed anyway, but not sure if this will workout...\nCheck the help information: popmap_maker.pl h\n\n"}
if ($popfin > 0 && $sampini <=  $sampfin || $sampfin > 0 && $sampini >= $sampfin) { print "\n\n\tERROR!\n$version was set read population and sample names by position in filename, sample name beginning should be lower than sample ending position...\nBut it is not. --sampini $sampini --sampfin $sampfin   I'll proceed anyway, but not sure if this will workout...\nCheck the help information: popmap_maker.pl -h\n\n"}
if ($popfin > 0 && $sampfin == 0) { print "\n\n\tERROR!\n$version was set read population and sample names by position in filename, but one or more parameters were not set, the four parameters need to be set. I'll proceed anyway, but not sure if this will workout...\nCheck the help information: popmap_maker.pl -help\n\n"}
if ($sampfin > 0 && $popfin == 0) { print "\n\n\tERROR!\n$version was set read population and sample names by position in filename, but one or more parameters were not set, the four parameters need to be set. I'll proceed anyway, but not sure if this will workout...\nCheck the help information: popmap_maker.pl --h\n\n"}


use Cwd qw(cwd);
if ($dir eq $default) { $dir = cwd; }

print "\n$version is processing filenames from $dir\n";

opendir(my $DIR, $dir) or die "\nUnable to open files at $dir: $!\n";						#open the directory with the files
my @allfiles = readdir($DIR);					#extract filenames
closedir($DIR);

#clean
my @files = ();
if ($filter eq $default) {
	foreach my $anything (@allfiles) {
		next if ($anything =~ /^\.$/);				#don't use any hidden file
		next if ($anything =~ /^\.\.$/);
		push (@files, $anything);
	}
}
else {
	print "Filtering file names... ";
	foreach my $anything (@allfiles) {
		next if ($anything =~ /^\.$/);				#don't use any hidden file
		next if ($anything =~ /^\.\.$/);
		next unless ($anything =~ /$filter/);
		#next unless ($anything =~ /.*\.ba.*/);
		push (@files, $anything);
	}
}

if ($first eq '.') { $first = '\.'; }
if ($last eq '.') { $last = '\.'; }
if ($popsep eq '.') { $popsep = '\.'; }



#save only part of the file name, discard duplicates

my %uniquevalues = ();

if ($last eq $default) {
	foreach my $file (@files) {
		my $keep = $file;
		$keep =~ s/^(.*?)$first.*/$1/;			#works!
		#$keep =~ s/^(.*?)\..*/$1/;			#works!
		$uniquevalues{$keep} = 42;
	}
}
else {
	foreach my $file (@files) {
		next if ($file =~ /^\.$/);				#don't use any hidden file
		next if ($file =~ /^\.\.$/);
		my $keep = $file;
		$keep =~ s/(.*)$last/$1/;
		$uniquevalues{$keep} = 42;
	}
}

my $filenum = scalar @files;
my $samplenum = scalar keys %uniquevalues;


print "$filenum files found, $samplenum unique names kept. Now reading populations...\n";
#now separate populations from samples IDs

my %printinfo = ();
my %uniquepops = ();
my $try = 0;


if ($poplength ne $default) {
	print "Using \'poplength $poplength\' criteria to differenciate population names\n";
	my $k = 0;
	foreach my $key (keys %uniquevalues) {
		#if ($k < 4) { print "the name is $key\n"; }
		my $sampname = $key;
		my $popname = substr ($key, 0, $poplength);
		$uniquepops{$popname} = 42;
		$printinfo{$sampname} = $popname;
		$k++;
	}
}
elsif ($popsep ne $default) {
	print "Using \'popsep $popsep\' criteria to differenciate population names\n";
	foreach my $key (keys %uniquevalues) {
		my $popname = $key;
		$popname =~ s/^(.*?)$popsep/$1/;
		$uniquepops{$popname} = 42;
		my $sampname = $key;
		$sampname =~ s/^.*?$popsep(.*)$/$1/;
		$printinfo{$sampname} = $popname;
	}
}
elsif ($popfin > 0 || $sampfin > 0) {
	print "Using \'popini\' and \'popfin\' criteria to differenciate population names\n";
	$popini = $popini - 1;
	$poplength = $popfin - $popini;
	$sampini = $sampini - 1;
	my $samplength = $sampfin + $sampini;
	
	foreach my $key (keys %uniquevalues) {
		my $popname = substr ($key, $popini, $poplength);
		$uniquepops{$popname} = 42;
		my $sampname = substr ($key, $sampini, $samplength);
		$printinfo{$sampname} = $popname;
	}
}
elsif ($alphanum == 1) {
	print "Saving alphabetical part of sample name as population names\n";
	foreach my $key (keys %uniquevalues) {
		my $popname = $key;
		my $sampname = $key;
		#$popname =~s/^([[:alpha:]])\d/$1/;	#save alphabetical part of the name
		#$popname =~s/^([[:alpha:]])[0-9].*/$1/;	#save alphabetical part of the name
		#$popname =~s/^(.*)[0-9].*/$1/;	# deletes the last number
		$popname =~s/^(\D*)[0-9].*/$1/;	#save alphabetical part of the name
		#$popname =~ s/^([a-zA-Z]*)[0-9]*\..*$/$1/;	#save alphabetical part of the name
		#if ($try < 11) { print "$popname\n"; }
		$uniquepops{$popname} = 42;
		$printinfo{$sampname} = $popname;
		$try++;
	}
}
else { die "\n\n\tUNEXPECTED ERROR!\n\nDid you parse --poplength; --popfin; or --sampfin with values of 0 or negative?\nThis message was not supposed to appear... I'm not sure who did something wrong here.\n\nTry to check the Help information it may be useful: popmap_maker.pl -h\n\n"; }

########### SAVE

my $popnum = scalar keys %uniquepops;

print "$samplenum samples from $popnum populations processed. Now printing files...\n";

open(my $OUT1, '>', $popmap) or die "error creating $popmap for saving the popmap data: $!";
#Loop over the hash, sort it and print it
foreach my $sorting (sort keys %printinfo) {
	print $OUT1 "$sorting$sep$printinfo{$sorting}\n";
}

my @path = split ('/', $dir);
my $folder = $path[-1];

my $indlist = "$folder" . "_ind-list";
open(my $OUT2, '>', $indlist) or die "error creating $indlist for saving the sample list: $!";
#Loop over the hash
foreach my $indivs (sort keys %printinfo) {print $OUT2 "$indivs\n";}
close $OUT2;

my $uniquepops = "$folder"."_unique-pops";
open(my $OUT4, '>', $uniquepops) or die "error creating $uniquepops for saving the populations list: $!";
#Loop over the hash
foreach my $pops (sort keys %uniquepops) {print $OUT4 "$pops\n";}
close $OUT4;

my $filelist = "$folder"."_file-list";
open(my $OUT5, '>', $filelist) or die "error creating $filelist for saving the list of files at $dir: $!";
#Loop over the hash
foreach my $onefile (@files) {print $OUT5 "$onefile\n";}
close $OUT5;

print "Files created succesfully!\n\n";

