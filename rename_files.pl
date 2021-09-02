#!/usr/bin/perl
use strict ; use warnings;

# rename_files   			# by M'Óskar 
my $version = "rename_files.pl";

############################

# Use this script to rename a bunch of files (pictures) according to the directory name
# check the help information (--h; -help; etc...) for more details: rename_files.pl help

##################################################################

#Changelog
my $edited = "29.07.2020";


######################   PARAMETERS   #########################
# All of them can and should be set from the command line, check the help.

my $dirname = "No default";  		# name of the directory to process
#my $dirname = "No default";  		# name of the directory to process

my $filter= "No default";  		#something all file names to process must have in common
#my $filter= "No default";  		#something all file names to process must have in common
#my $filter= "*.jpg$";  		#something all file names to process must have in common

my $long = 0;  		#do you want the name to include all directories in path?
#my $long = 0;  		#do you want the name to include all directories in path?
#my $long = 1;  		#do you want the name to include all directories in path?

my $alldir = 0;  		#do you want to process all files in all subdirectories?
#my $alldir = 0;  		#do you want to process all files in all subdirectories?
#my $alldir = 1;  		#do you want to process all files in all subdirectories?

my $head = "No default";  		#do you want to add something at the beginning of all file names?
#my $head = "No default";  		#do you want to add something at the beginning of all file names?
#my $head = "processed_";  		#do you want to add something at the beginning of all file names?

my $tail = "No default";  		# do you want to add something at the end of the file names?
#my $tail = "No default";  		# do you want to add something at the end of the file names?
#my $tail = "_tail";  		# do you want to add something at the end of the file names?

my $ext = "No default";  		# do you want to replace the files extensions?
#my $ext = "No default";  		# do you want to replace the files extensions?
#my $ext = ".ext";  		# do you want to replace the files extensions?

my $keep = 0;  		# do you want the old name file to be kept?
#my $keep = 0;  		# do you want the old name file to be kept?
#my $keep = 1;  		# do you want the old name file to be kept?

my $move = "No default";  		# do you want to move all renamed files to the same directory?
#my $move = "No default";  		# do you want to move all renamed files to the same directory?
#my $move = "home/files";  		# do you want to move all renamed files to the same directory?


#################################################################################################################
#################################################################################################################


#Help!
my %arguments = map { $_ => 1 } @ARGV;
if(exists($arguments{"help"}) || exists($arguments{"--help"}) || exists($arguments{"-help"}) || exists($arguments{"-h"}) || exists($arguments{"--h"}) || exists($arguments{"--h"})) {
	die "\n\n\t   $version $edited Help Information\n\t-------------------------------------------------\n
\tThis program will rename all files in the a directory or directories.
\tFile types can be filtered, name will be determine by directory name and some options.
\tIf there is two or more files in a directory they will be numered.
\t\n\tCommand line arguments and defaults:
\t--dir                     name/path of the directory to process. Default: working directory.\n
\t--filter                  to only analyse files that match certain pattern. Use regex. $filter. 
\t                          only vcf files: --filter \".*\\.vcf\$\"; only with certain beginning: --filter \"^candidate.*\"\n
\t--all                     [flag] add this if you want to process files all subdirectories\n
\t--long                    [flag] add this if you want the file names to include every directory in path\n
\t--head                    in case you want to add something at the beginning of file names. $head.\n
\t--tail                    to add something at the end of the file names (before the extension). $tail.\n
\t--ext                     to add a different extension at the end of the file name. $ext. Example: \".txt\"\n
\t--keep                    [flag] add this to append directory name to the original file name instead of replacing it.\n
\t--cp                      Add a path to a directory (will be created if needed) to copy al the renamed files.
\t                          Warning: unless you use this option, renamed files will overwrite the originals. $move
\n\n\tCommand line call example:\n\trename_files.pl --all --filter \".*IMG.*\" --cp \"out/files\"\n\n\n";
}



################ PARSING ARGUMENTS

use Getopt::Long;

GetOptions( "dir=s" => \$dirname,    #   --dir
            "filter=s" => \$filter,      #   --filter
            "all" => \$alldir,      #   --all
            "long" => \$long,      #   --long
            "keep" => \$keep,      #   --keep
            "head=s" => \$head,      #   --head
            "tail=s" => \$tail,      #   --tail
            "cp=s" => \$move,      #   --cp
            "ext=s" => \$ext );   #   --ext




print "\n$version is running...\n";


############### DIRECTORY PATH

use Cwd qw(cwd);
my $localdir = cwd;
if ($dirname eq "No default") { $dirname = $localdir; }

#handle options
my $pattern;
if ($filter eq "No default") { $pattern = ".*"; } else { $pattern = $filter; }


#save path to directories

my @subdirs = ();

if ($alldir == 1) {
	use File::Find::Rule;
	print "\nLooking for subdirectories at $localdir\n";
	@subdirs = File::Find::Rule->directory()->in($dirname);
	#foreach my $dir (@subdirs) { print "$dir\n"; }
	my $numdirs = scalar @subdirs;
	print " Found $numdirs directories and sub-directories\n";
}
elsif ($alldir == 0) { @subdirs = ("$localdir") }

use File::Copy;

#check files in each dir
foreach my $dir (@subdirs) {
	my $k=0;
	
	my $workingdir = $dir;
	my @files = ();
	print "\nListing matching files at $workingdir: ";
	
	# for each working dir select files.
	opendir(DIR, $workingdir);						#open the directory 
	while (my $file = readdir(DIR)) {
		next unless (-f "$workingdir/$file");
		next unless ($file =~ /$pattern/);				#don't use any hidden file
		push (@files, $file);
		#print "$file\n";
	}
	closedir(DIR);
	
	my $filenum = scalar @files;
	
	if ($filenum == 0) { print "$filenum files found\n Checking next directory\n"; }
	elsif ($filenum > 0) { print "$filenum\n"; }
	
	next if ($filenum == 0);
	
	my %fileref = ();
	
	#rename files in dir
	foreach my $file (@files) {
	
		my @nameparts = split ('\.', $file);
		#print "$file parts: @nameparts\n";
		my $endref = $nameparts[-1];
		my $onlyname = $file;
		$onlyname =~ s/^(.*)\.$endref$/$1/;
		
		# count how many files with the same extension there is
		if (exists $fileref{$endref}) { $fileref{$endref} = $fileref{$endref} + 1; } else { $fileref{$endref} = 1; }
		
	}
	
	my %filecount = ();
	foreach my $file (@files) {
		
		my $newfile = "mamandurria";
		
		#generate name from dir
		my @alldirs = split ('/', $workingdir);
		my $folder = "menemene";
		if ($long == 0) { $folder = $alldirs[-1]; } elsif ($long == 1) { $folder = join ('_', @alldirs); }
		
		#extract extension
		my @nameparts = split ('\.', $file);
		#print "$file parts: @nameparts\n";
		my $oldend = $nameparts[-1];
		my $filename = $file;
		$filename =~ s/^(.*)\.$oldend$/$1/;
		
		#check how many files there is with the same extension
		my $refnum = $fileref{$oldend};
		if (exists $filecount{$oldend}) { $filecount{$oldend} = $filecount{$oldend} + 1; } else { $filecount{$oldend} = 1; }
		my $num = $filecount{$oldend};
		
		if ($refnum == 1) { $num = ""; }
		elsif ($refnum < 10) { $num = "_$num"; }
		elsif ($refnum < 100 && $num < 10) { $num = "_0" . "$num"; }
		elsif ($refnum < 100 && $num > 9) { $num = "_$num"; }
		elsif ($refnum < 1000 && $num < 10) { $num = "_00$num"; }
		elsif ($refnum < 1000 && $num < 100) { $num = "_0$num"; }
		elsif ($refnum < 1000 && $num > 99) { $num = "_$num"; }
		elsif ($refnum < 10000 && $num < 10) { $num = "_000$num"; }
		elsif ($refnum < 10000 && $num < 100) { $num = "_00$num"; }
		elsif ($refnum < 10000 && $num < 1000) { $num = "_0$num"; }
		elsif ($refnum < 10000 && $num > 999) { $num = "_$num"; }
		else { $num = "_$num"; }
		
		#declare elements 
		if ($head eq "No default") { $head = ""; }
		if ($tail eq "No default") { $tail = ""; }
		
		#rename
		if ($keep == 1 && $ext ne "No default") { $newfile = "$head$folder" . "_$filename$tail" . ".$oldend" . ".$ext"; }
		elsif ($keep == 1 && $ext eq "No default") { $newfile = "$head$folder" . "_$filename$tail" . ".$oldend"; }
		elsif ($keep == 0 && $ext ne "No default") { $newfile = "$head$folder$tail" . "$num$ext"; }
		elsif ($keep == 0 && $ext eq "No default") { $newfile = "$head$folder$tail" . "$num" . ".$oldend"; }
		else { die "\n\nERROR!\n\nThere has been some problem handling the options to keep old file name and extension.\nThis message was not supposed to appear..."; }
		
		$newfile =~ s/ /_/g;
		
		my $origin = "$dir/$file";
		$origin =~ s/\/\//\//g;
		
		if ($move eq "No default") { 
			my $destiny = "$dir/$newfile";
			$destiny =~ s/\/\//\//g;
			move("$origin", "$destiny");
		}
		else { 
			unless(-e $move or mkdir $move) {die "Unable to create output directory $move\n\n"};
			my $destiny = "$move/$newfile";
			$destiny =~ s/\/\//\//g;
			#print "\n$origin -> $destiny\n";
			copy("$origin", "$destiny");
		}
		$k++;
	
	}
	
	print "All $k files renamed\n";
	
}





print "\n\nDone! $version finished.\n\n";

