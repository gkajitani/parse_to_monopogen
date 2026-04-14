# parse_to_monopogen
Pipeline for variant calling from single cell/nucleus data using Parse Biosciences kits.

Adapted from Monopogen, an analysis package for SNV calling from single-cell sequencing (https://doi.org/10.1038/s41587-023-01873-x).

As Monopogen requires a single bam file for each sample, a demultiplex step was added for Parse Bioscience data.

Monopogen.py was also edited to avoid using too many resources when using beagle for converting genotype likelihood to genotype probability.
