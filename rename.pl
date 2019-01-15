#!/usr/bin/perl  
# rename.pl by M'Óscar

###################################################################################

# Quick script to rename files in the local working directory.
# Either all files in a specific folder or the files with a specific extension or pattern in the name
# Either adding something at the beginning or at the end or both.
# I will implement some ways to completely rename it, but for more complex opperations I recommend "RenameMaster"
# Rename Master: http://www.joejoesoft.com/vcms/108/

# So far, the only implemented set is to add a prefix and/or a suffix after the name, but before the extention.

###################################################################################

my $pattern ="tsv";		# Patter that all the files to rename should have in common in the name
# my $pattern ="ALLFILES";		# Use "ALLFILES" if all the files in the folder with no exception should be renamed

my $newini = "NOPRE";		# Use "NOPREP" if you do not want to add anything at the beginning of the new name
# my $newini = "renamed";		# Prefix that should be added to the new name

my $newend = "_onlypmel";		# Suffix that should be added to the new name (before the extension).
# my $newend = "NOSUF";		# Use "NOSUF" if you do not want to add anything at the end of the new name

# my $newext = ".csv";		# Extension that should be added to the new name (usually ".txt" or similar)
my $newext = "SAMEEXT";		# Use "SAMEEXT" if you do not want to change the file extension.

my $rmext = "NO";		# If you want to keep the original extension of the file
# my $rmext = "YES";		# If you want to remove the original extension of the file

my $fullrename = "NO";		#This is the deffault route to just add a prefix and/or suffix to filenames
# my $fullrename = "YES";		#This will activate the route for a more complex renaming. Use with caution.

unless ($newini ne "NOPRE" || $newend ne "NOSUF" || $fullrename ne "NO" || $newext ne "SAMEEXT" || $rmext ne "NO") {die "\nOutput file names would be the same than the original file names, kind of pointless to continue.\nOpen \"rename.pl\" check the settings and try again\n\n";}

my $newfolder = "out";		#output folder

use Cwd qw(cwd);
my $localdir = cwd;


unless(-e $newfolder or mkdir $newfolder) {die "Unable to create the directory \"$newfolder\" at\n$localdir\nMay be you don't have the rights: $!\n"; }



print "\nUsing directory \"$newfolder\" to contain the outputs.\nNow reading files at $localdir\n\n";
print "Renaming files...\n";

use File::Copy qw(copy);


opendir(DIR, $localdir);						#open the directory with the files
my @files = readdir(DIR);					#extract filenames
closedir(DIR);

my $count = 0;

foreach my $file (@files) {					#process all the files one by one
	
	next if ($file =~ /^\.$/);				#don't use any hidden file
	next if ($file =~ /^\.\.$/);			
	
	if ($pattern ne "ALLFILES") {
		next unless ($file =~ /$pattern/);		#read only files
	}
	
	my $filepath = $localdir . "/". $file;
	
	print "$file  ";
	
	# extract the extension and the rest of file name from the full file name
	
	my @fullname= split('\.', $file);
	
	
	my $fileext = $fullname[-1];
	pop (@fullname);
	
	my $filename = join ("." , @fullname);
	
	my $newname = $file;
	#$newname =~ s/-/_/g;
	#$newname =~ s/\./_/g;
	
	#@splittedname= split('_', $newname);
	#my $pop1 = $splittedname[2];
	#my $pop2 = $splittedname[3];
	
	my $outname = $newname;
	
	# Adding affixes
	
	if ($newini ne "NOPRE") {
		$outname = "$newini" . "$newname";
	}
	
	if ($newend ne "NOSUF" && $rmext eq "NO") {
		$outname = "$filename" . "$newend" . "." . "$fileext";
	}
	
	#saving
	
	my $outpath = "$localdir" . "/" . "$newfolder" . "/" . "$outname";
	my $inpath = "$localdir" . "/" . "$file";
	
	copy $inpath, $outpath;
	
	$count++;
}

if ($count == 0) { print "ERROR! No files were found.\nMay be there are not files maching \"$pattern\" at $localdir". "?\n\n";}
else {print "\n\nDone! $count files renamed.\n\n";}
