#!/usr/bin/perl
#transpose1.pl
use strict ; use warnings;
#by M'Ósky 2018

# Will transpose any file in the folder
# It's based in a script written by Frederic PONT: https://sites.google.com/site/fredsoftwares/products/transpose-tables




########## Specific parametres 
my $transfilter = "genepop";		# a string that must be present in the input file name in order to process it
my $transout = "_trans";		#this will be added at the end of the transposed output files
my $results_folder = "trans" ;		#out folder for your transposed files

########## Parameters inherited from previous script
my $outfolder = "bypop";		#output folder to use/create that includes the files to process
my $sep = "\t";

use Cwd qw(cwd);
my $localdir = cwd;
my $newfolder = "$localdir" . "/" . "$outfolder";
my $resultspath = "$localdir" . "/" . "$results_folder";

################

unless(-e $resultspath or mkdir $resultspath) {die "\nUnable to create \"$results_folder\" at\n$newfolder\nMay be you don't have the rights: $!\n"; }


opendir(DIR, $newfolder) || die "can't opendir $newfolder: $!";						#open the directory with the files
my @genepopfiles = readdir(DIR);					#extract filenames
closedir(DIR);

my $filenumber = 0;
print "\nReading files from $newfolder:\n" ;
foreach my $popfile (@genepopfiles) {					#process all the files one by one
	next if ($popfile =~ /^\.$/);				#don't use any hidden file
	next if ($popfile =~ /^\.\.$/);			
	next unless ($popfile =~ /\.$transfilter.*$/);		#read only genepop files
	transpose_table($popfile, $sep);
	print "\tdone!\n";
	$filenumber++;
}

print "\n$filenumber files were transposed and saved in directory \"$results_folder\".\n";
















sub transpose_table {
  my $popfile = shift ;
  my $sep = shift ;

  my $file = "$newfolder/$popfile" ;
  my $transposed_file = "$resultspath/$popfile$transout" ;
  my @data ;
  my $size ;
  my @size ;
  my $size_temp ;
  my @tmp ;
  my $line ;
  

  open F, '<', $file or die "Couldn't read from $file file: $!";
  open T, '>', $transposed_file or die "Couldn't write to $transposed_file file: $!";

	# test if the first 3 lines are identical, die if not
	for  my $i (1 .. 3 ){
		$line = (<F>);
		chomp $line;
		@tmp  = $line =~ /$sep/g;
		$size[$i-1] =  @tmp +1 ; # table size, nb of columns in the non transposed table -> nb of lines after transposition
	}
	close(F) ;
	($size[0]  == $size[1]  and $size[0] == $size[2]) ? print "transposing $popfile" : die "Legth of the lines are different\n" ;

	
	open F, '<', $file or die "Couldn't read from $file file: $!";
  #my $l = 1; # line #
  my $c = 1 ; # column #
  while ($line = <F>)
    {
		chomp $line;
		$line =~ s/\s+$//;		#clean white tails in lines
	    @tmp  = split "$sep", $line;
	    $data[$c] = [ @tmp ];
        my @count  = $line =~ /$sep/g; # count the nb of separators
	    $size = @count +1 ; # table size, nb of columns in the non transposed table -> nb of lines after transposition
	    $size  ==  $size[1] ? 1 : die "Error the size of the table is not constant at line $c : $size  instead of  $size[1]\n" ;
	    ++$c ;
    } 
  print " ... " ;


  for (my $i = 0 ; $i < $size ; $i++){
    for (my $j = 1 ; $j < $c ; $j++){
      # print "i:$i , j:$j\n";
      if ($j < $c -1 ) {
          if (exists $data[$j][$i])  {
                #print "$data[$j][$i]"."$sep";
	            print T $data[$j][$i]."$sep" ;
          } else {
              print T "$sep" ;
          }
	    
      }
      else {
	    # suppress the last separator
        if (exists $data[$j][$i])  {
	        #print "$data[$j][$i]";
	        print T $data[$j][$i];
        }
      }
    }
    
    #print "\n";
    print T "\n";
  }
  close F;
  close T;
}


