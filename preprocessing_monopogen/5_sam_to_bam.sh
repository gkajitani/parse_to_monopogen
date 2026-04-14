#!/bin/bash

# Loop through all .bam files in all subfolders
find . -type f -name "*.bam" | while read -r bamfile; do
	# Get the base name of the file (without extension)
	base_name=$(basename "$bamfile" .bam)
    
	# Get the directory of the file
	dir_name=$(dirname "$bamfile")
    
	# Perform the samtools command
	samtools view -@ 50 -bS "$bamfile" > "${dir_name}/${base_name}_fixed.bam"
done
