#!/bin/bash 
#I know this is too simple to be here. It is here as a reminder and statement.
# I'm tired of most programs used in genomics either failing to write results if output directory does not exist or the oposite, failing to overwrite if they do exist



DIRECTORY="out/results"
if [ -d "$DIRECTORY" ]
then 
	printf "Already existing sub-directories will be used as output directories: $DIRECTORY\n"
else 
	mkdir -p $DIRECTORY
	printf "Output directories created succesfully: $DIRECTORY\n"
fi













