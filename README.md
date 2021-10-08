# Handle and Edit Files
Miscelaneous scripts used to handle files, columns, rename, etc
Most of them are quite old and can be done with a one liner in perl, or by using 'awk' or 'sed', but may be useful for someone else.

The more simple have a few lines explaining at the beginning of the script, other have --help information

The only ones I still use in order to no have to come up with a oneliner in Perl or similar are:
- fixnumeration: If you have problem sorting samples because A2 is sorted after A19, this will add zeroes to the left (A02)
- popmap_maker: if your file names include the sample and population code it will make a popmap for you - file with a column with sample IDs and another of population codes.
  Lots of softwares (Stacks, FastStructure..) will ask for a popmap file with this format
- rename_files: Use this script to rename a bunch of files (pictures) according to the directory name, check the help information (--h; -help; etc...) for more details.
- row_multiplier: use this to duplicate as many times as needed the rows of a file, check its help information if needed
- transpose: Will transpose any file in the folder. It's based in a script written by [Frederic PONT](https://sites.google.com/site/fredsoftwares/products/transpose-table)
- extract_columns: this can be done with cut or similar commands, but may be helpful for someone starting. Use --help to check the options.
