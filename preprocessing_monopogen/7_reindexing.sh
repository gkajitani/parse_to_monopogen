#!/bin/bash

# Loop through all pre_*.bam files in all subfolders
find . -type f -name "pre_*.bam" | while read -r bamfile; do
	# Perform the samtools index command
	samtools index -@ 50 "$bamfile"
done
