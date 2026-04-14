# Note: This can also be performed on gp.vcf.gz files

# Index:
for file in *phased.vcf.gz; do
  bcftools index $file
done

# Sort:
for file in *phased.vcf.gz; do
  bcftools sort $file -o sorted.$file
done

# Move sorted files:

mkdir sorted_files
mv sorted* sorted_files
cd sorted_files

# Index again:
for file in *phased.vcf.gz; do
  bcftools index $file
done

# Combine
nohup bcftools concat -a -o combined_phased.vcf.gz -O z *phased.vcf.gz
