# Handle and Edit Files
Miscelaneous scripts used to handle files, columns, rename, etc
Most of them are quite old and can be done with a one liner in perl, or by using 'awk' or 'sed', but may be useful for someone else.

The more simple have a few lines explaining at the beginning of the script, other have --help information

The only ones I still use in order to no have to come up with a oneliner in Perl or similar are:
- fixnumeration: If you have problem sorting samples because A2 is sorted after A19, this will add zeroes to the left (A02)
- popmap_maker: if your file names include the sample and population code it will make a popmap for you - file with a column with sample IDs and another of population codes.
  Lots of softwares (Stacks, FastStructure..) will ask for a popmap file with this format
