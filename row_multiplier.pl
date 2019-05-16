#!/usr/bin/perl
use strict; use warnings;

# row_multiplier  			# by M'Óskar
my $program_name = "row_multiplier.pl";

#use this to duplicate as many times as needed the rows of a file
#check help information if needed: row_multiplier.pl 







#########################################################################################
#########################################################################################


#######################   DEFAULT PARAMETERS   #########################
# All of them can be set from the command line

my $inputname = "samplelist.txt";
my $multiplier = 8;


#########################################################################################
#########################################################################################

my $tail = "_out";   		#to be added at the end of the inputfile name to generate the output file name

use Cwd qw(cwd);
my $localdir = cwd;
my $rest = $multiplier-1;
my $HELP ="\n\n\t   $program_name   Help Information\n\t-------------------------------------------------\n
	This program will duplicate each row of a file. As many times as needed.
	by default will be $multiplier times (add $rest duplicates of each row below it)
	I use this to get the first column of individual IDs for inputfiles that have more than one row per individual
	you can take a sample list and duplicate it to fit the number of rows per sample you needed
	Default input file name is \"$inputname.
	The output file name will be done by adding \"$tail\" to the inputname (and the \".txt\" extension if there isn't any)\n\tDefaults can be changed from command line. Examples:
	\t$program_name \n\t\t$program_name filename\n\t\t$program_name 42\n\t\t$program_name file.csv 8\n\t\t$program_name 2 samplelist.txt\n\n\n";

my $argumentnumber = scalar (@ARGV);
my %arguments = map { $_ => 1 } @ARGV;


if($argumentnumber == 0) {print "\nNo arguments specified, will use duplicate columns from $inputname x$multiplier times\n";
}
elsif($argumentnumber == 1) {
	my $argument = $ARGV[0];
	if(exists($arguments{"help"}) || exists($arguments{"--help"}) || exists($arguments{"-help"}) || exists($arguments{"-h"}) || exists($arguments{"--h"})) {
		die "$HELP";
	}
	if ( $argument =~ /^[0-9,.E]+$/ ) {
		$multiplier = $argument;
		print "\nOne numeric argument passed (multiplier for rows), will duplicate rows x$multiplier times in the file \"$inputname\"\n";
	}
	else {
		$inputname = $argument;
	print "\nOne argument passed (input file name), will duplicate rows x$multiplier times in the file \"$inputname\"\n";
	}
}
elsif($argumentnumber == 2) {
	my $argument = $ARGV[0];
	if ( $argument =~ /^[0-9,.E]+$/ ) {
		$multiplier = $argument;
		$inputname = $ARGV[1];
		print "\nTwo arguments passed (multiplier for rows and file name), will duplicate rows x$multiplier times in the file \"$inputname\"\n";
	}
	else {
		$inputname = $argument;
		$multiplier = $ARGV[1];
		print "\nTwo arguments passed (file name and multiplier for rows), will duplicate rows x$multiplier times in the file \"$inputname\"\n";
	}
}
else {
	die "\n\tSomething is wrong. Did you specify more than two arguments? Check help information if needed.\n\t$program_name --h\n\t$program_name help\n\tetc...\n\n";
}



#########################################################################################
#########################################################################################

print "\nProcessing $inputname...";

my @filename = split('\.', $inputname);

my $size = scalar (@filename);

my $keepname = "default";
my $extension = ".none";
if ($size == 2) {
	$extension = "." . "$filename[-1]";
	$keepname = $filename [0];
}
elsif ($size > 2) {
	$extension = "." . "$filename[-1]";
	pop(@filename);
	$keepname = join(".", @filename);
}
elsif ($size == 1) {
	$keepname=$inputname;
	$extension=".txt"
}

my $outname = "$localdir" . "/" . "$keepname" . "$tail" . "$extension";		#name for the output file
my $filepath = "$localdir" . "/" . "$inputname";

open my $FILE, '<', $filepath or die "\nUnable to find or open $filepath: $!\n";

my @outdata =();
my $k=0;

while (<$FILE>) {
	chomp;	#clean "end of line" symbols
	
	next if /^(\s*(#.*)?)?$/;   # skip blank lines and comments
	
	my $line = $_;
	$line =~ s/\s+$//;		#clean white tails in lines
	
	my $count = 0;
	
	while ($count < $multiplier) {
		push (@outdata, $line);
		$count++;
	}
	$k++;
}

close $FILE;

print " Done!\n $k lines processed and multiplied\n";

open my $OUTL, '>', $outname or die "\nUnable to create or save $outname: $!\n";

# Loop over the array
foreach (@outdata) {print $OUTL "$_\n";} # Print each entry in our array to the file
close $OUTL;

print "\nNew file saved as: $outname\nALL DONE!\n\n";





