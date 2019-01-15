#!/usr/bin/perl
#extract_columns.pl
use strict ; use warnings;
#by M'Ósky 2018

#This will extract a range of columns from a file. Type "extract_columns.pl --h", "extract_columns.pl help", or any other variant to see the usage/help.

#OPTIONS TO CONFIGURE
my $sep = "\t"; 		#Column separator



#TRICKY OPTIONS TO CONFIGURE, CAREFUL HERE
#my $skip = "^(\s*(#.*)?)?$"; 		#Skip blank lines and comments (using the "match" // function)
my $skip = "^##.*"; 		#Skip blank lines and only double comments "##" (using the "match" // function)


#DEFAULT VALUES. Can be passed from command line in an easier way. Check the help file

my $filename = "populations.snps.vcf";
my $colini = 1;
my $colfin = 5;


#######################################################



my $argumentnumber = scalar (@ARGV);
my $argument1 = $ARGV[0];
my %arguments = map { $_ => 1 } @ARGV;

if(exists($arguments{"help"}) || exists($arguments{"--help"}) || exists($arguments{"-help"}) || exists($arguments{"-h"}) || exists($arguments{"--h"})) {
	die "\nNeed some help with this?\n\n This program will extract extract a number of columns from a file. The file should be in the local directory.\n By default it assumes that the columns are 'tab' separated, you can edit this in the script. The name of the file and columns to extract can be set as arguments in the command line.\n\nUSAGE: call the program to extract columns $colini to $colfin from $filename. Modify defaults from command line.\nExamples: extract_columns.pl inputfile.csv  \t  # Extract columns $colini to $colfin from inputfile.csv\n\t  extract_columns.pl 4  \t\t  # Extract the first 4 columns from $filename\n\t  extract_columns.pl myfile.txt 8  \t  # Extract the first 8 columns from myfile.txt\n\t  extract_columns.pl 42 anotherfile.txt   # Extract the first 42 columns from anotherfile.txt\n\t  extract_columns.pl 12 14  \t\t  # Extract columns from 12 to 14 from $filename\n\t  extract_columns.pl 2 36 somefile.xml    # Extract columns from 2 to 36 from somefile.xml\n\t  extract_columns.pl yetanother 6 10  \t  # Extract columns from 6 to 10 from the file \"yetanother\"\n\n";
}

if($argumentnumber == 0) {print "\nNo arguments passed (ussing defaults), will extract columns $colini to $colfin from \"$filename\".\n";}
elsif($argumentnumber == 1) {
	if ( $argument1 =~ /^[0-9,.E]+$/ ) {
		$colfin = $argument1;
		print "\nOne numeric argument passed (number of columns to extract), will extract columns $colini to $colfin from the defaut input file \"$filename\".\n";;
	}
	else {
		$filename = $argument1;
	print "\nOne alphanumeric argument passed (input file name), will open the file \"$filename\" and extract the default number of columns (the first $colfin).\n";
	}
}
elsif($argumentnumber == 2) {
	my $argument2 = $ARGV[1];
	if ( $argument1 =~ /^[0-9,.E]+$/ && $argument2 !~ /^[0-9,.E]+$/) {
		$colfin = $argument1;
		$filename = $argument2;
		print "\nTwo arguments passed (number of columns to extract and file name), will extract columns $colini to $colfin from the file \"$filename\".\n";
	}
	elsif ( $argument1 !~ /^[0-9,.E]+$/ && $argument2 =~ /^[0-9,.E]+$/) {
		$colfin = $argument2;
		$filename = $argument1;
		print "\nTwo arguments passed (file name and number of columns to extract), will open \"$filename\" and extract columns $colini to $colfin.\n";
	}
	elsif ( $argument1 =~ /^[0-9,.E]+$/ && $argument2 =~ /^[0-9,.E]+$/) {
		$colini = $argument1;
		$colfin = $argument2;
		print "\nTwo numeric values passed (range of columns to extract), will extract the columns from $colini to $colfin from the default file \"$filename\".\n";
	}
	else {
		die "\nERROR: Did you pass two alphanumeric arguments from command line?\nType \"extract_columns.pl --h\", \"extract_columns.pl help\", or any other variant for help\n\n";
	}
}
elsif($argumentnumber == 3) {
	my $argument2 = $ARGV[2];
	if ($argument1 =~ /^[0-9,.E]+$/ ) {
		$colini = $argument1;
		$colfin = $ARGV[1];
		$filename = $argument2;
		print "\nThree arguments passed. Two numeric values (range of columns to extract) and file name, will extract columns $colini to $colfin from \"$filename\".\n";
	}
	elsif ($argument2 =~ /^[0-9,.E]+$/ ) {
		$filename = $argument1;
		$colini = $ARGV[0];
		$colfin = $argument2;
		print "\nThree arguments passed. File name and two numeric values (range of columns to extract), will open \"$filename\" and extract columns $colini to $colfin.\n";
	}
	else {
		die "\nERROR: Did you pass more than one alphanumeric argument from command line?\nType \"extract_columns.pl --h\", \"extract_columns.pl help\", or any other variant for help\n\n";
	}
}
else {
	die "\n\tSomething is wrong. Did you specify more than three arguments?\\nType \"extract_columns.pl --h\", \"extract_columns.pl help\", or any other variant for help\n\n";
}

print "Reading $filename...";




use Cwd qw(cwd);
my $localdir = cwd;
my $filepath = "$localdir" . "/" . "$filename";


open my $FILE, '<', $filepath or die "\nUnable to find or open $filename at $localdir: $!\nType \"extract_columns.pl --h\", \"extract_columns.pl help\", or any other variant for help\n\n";

my $ini = $colini - 1;
my $fin = $colfin - 1;
my @tosave = ();

while (<$FILE>) {
	chomp;	#clean "end of line" symbols
	next if /$skip/;   # Skip lines
	
	my $line = $_;
	$line =~ s/\s+$//;		#clean white tails in lines
	my @newline= split($sep, $line);	#split columns as different elements of an array
	my @keep = @newline[$ini..$fin];
	my $choosen = join ($sep, @keep);
	push (@tosave, $choosen);
}

close $FILE;
print "   Done!\nNow saving de columns...";


my $outname = "subset_" . "$filename";
my $outpath = "$localdir" . "/" . "$outname";

open my $OUT, '>', $outpath or die "\nUnable to create or save \"$outname\" at $localdir: $!\n";
foreach (@tosave) {print $OUT "$_\n";} # Print each entry in our array to the file
close $OUT;
print "   Done!\nResults saved as $outname\nAll done!\n\n";




























	
	
	