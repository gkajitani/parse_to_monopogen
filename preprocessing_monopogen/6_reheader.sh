#!/bin/bash

# Loop through all _fixed.bam files in all subfolders - Removing hg38_ from header
find . -type f -name "*_fixed.bam" | while read -r bamfile; do
	# Get the base name of the file (without the _fixed.bam suffix)
	base_name=$(basename "$bamfile" "_fixed.bam")
    
	# Get the directory of the file
	dir_name=$(dirname "$bamfile")
    
	# Extract the header, modify it, and save to a new file
	samtools view -H "$bamfile" | sed 's/^@SQ\tSN:hg38_/@SQ\tSN:/' > "${dir_name}/${base_name}_fixed_new_header.txt"
done

find . -type f -name "*_fixed.bam" | while read -r bamfile; do
	# Get the base name of the file (without the _fixed.bam suffix)
	base_name=$(basename "$bamfile" "_fixed.bam")
    
	# Get the directory of the file
	dir_name=$(dirname "$bamfile")
    
	# Define the paths for the header file and output file
	header_file="${dir_name}/${base_name}_fixed_new_header.txt"
	output_file="${dir_name}/pre_${base_name}.bam"
    
	# Perform the samtools reheader command
	samtools reheader "$header_file" "$bamfile" > "$output_file"
done
