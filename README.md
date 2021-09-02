# files_and_various
Miscelaneous scripts used to handle files, columns, rename, etc
Most of them are quite old and can be done with a simple one liner in perl, but may be useful for someone starting.

The more simple have a few lines explaining at the beginning, other have -help information

The only ones I still use in order to no have to come up with a oneliner in Perl:
- fixnumeration: If you have problem sorting samples because A2 is sorted after A19, this will add zeroes to the left (A02)
- popmap_maker: if your file names include the sample and population code it will make a popmap for you - file with a column with sample IDs and another of population codes.
  Lots of softwares (Stacks, FastStructure..) will ask for a popmap file with this format
