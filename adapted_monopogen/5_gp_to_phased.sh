#!/bin/bash

# Using beagle for allele phasing

# Directory containing the .gp.vcf.gz files
input_dir="./"

# Path to the Beagle JAR file
beagle_jar="/Monopogen/apps/beagle.27Jul16.86a.jar"

# Base path for the reference files
ref_base="/1K3G_imputation_panel/CCDG_14151_B01_GRM_WGS_2020-08-05_"

# Number of threads to use
nthreads=52

# Maximum number of parallel jobs
max_jobs=4

# Function to process a single file
process_file() {
	local input_file=$1
	local chrom=$(echo $input_file | grep -oP 'chr\d+')
	local ref="${ref_base}${chrom}.filtered.shapeit2-duohmm-phased.vcf.gz"
	local out="${input_file%.gp.vcf.gz}.phased"

	echo "Processing $input_file with chromosome $chrom"
	nohup java -Xmx20g -jar $beagle_jar \
    	gt=./$input_file \
    	ref=$ref \
    	chrom=$chrom \
    	out=./$out \
    	impute=false \
    	modelscale=2 \
    	nthreads=$nthreads \
    	gprobs=true \
    	niterations=0 > "${out}.log" 2>&1 &
}

# Array to store background job PIDs
declare -a job_pids

# Process files in the input directory
for input_file in "$input_dir"/*.gp.vcf.gz; do
	# If the number of running jobs exceeds max_jobs, wait for one to finish
	while [[ $(jobs -r | wc -l) -ge $max_jobs ]]; do
    	sleep 1
	done

	# Start a new job
	process_file "$(basename "$input_file")"
	job_pids+=($!)
done

# Wait for all background jobs to finish
for pid in "${job_pids[@]}"; do
	wait "$pid"
done

echo "All files have been processed."
