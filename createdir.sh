#!/bin/bash 


DIRECTORY="out/results"
if [ -d "$DIRECTORY" ]
then 
	printf "Already existing sub-directories will be used as output directories: $DIRECTORY\n"
else 
	mkdir -p $DIRECTORY
	printf "Output directories created succesfully: $DIRECTORY\n"
fi













