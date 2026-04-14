#!/bin/bash

# Set the memory and thread parameters
MEMORY="30GB"
THREADS=40

# Define the base directory where your BAM files are located - e.g. MEGA1
BASE_DIR="/your/directory/MEGA1"

# Counter for output files
counter=1

# Getting bam files from subdirectories - Parse data bam files are named "barcode_headAligned_anno.bam"
find "$BASE_DIR" -type f -path "*/MEGA1_run*" -name "barcode_headAligned_anno.bam" -print0 | while IFS= read -r -d '' bam_file; do
	echo "Processing $counter: $(basename "$(dirname "$bam_file")")/$(basename "$bam_file")"
    
	# Define the output file name
	output_file="barcode_sorted_${counter}.bam"
    
	# Run sambamba sort
	sambamba sort -m "$MEMORY" -t "$THREADS" --tmpdir ./ -o "$output_file" "$bam_file"
    
	echo "Saved as: $output_file"
	((counter++))
done

# Check if any files were processed
if [ $counter -eq 1 ]; then
	echo "No BAM files found matching the pattern."
	exit 1
fi

echo "All .bam files have been processed."
