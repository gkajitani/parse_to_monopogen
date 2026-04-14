#!/bin/bash

# Monopogen needs a “bam.lst” file containing the sample names + file names, separated by comma. 
# Samples are separated by line breaks, e.g.:
# sample_10_B18,./pre_sample_10_B18.bam
# sample_10_B19,./pre_sample_10_B19.bam

# Clear the content of bam.lst if it already exists
> bam.lst

# Loop through all .bam files in the current directory
for bam_file in *.bam; do
	# Extract the part of the filename after "pre_"
	sample_name="${bam_file#pre_}"
	# Remove the .bam extension
	sample_name="${sample_name%.bam}"
	# Write the desired format to bam.lst
	echo "$sample_name,./$bam_file" >> bam.lst
done
