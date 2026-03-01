# HG002 Variant Calling Pipeline
#Commands Documentation


This repository contains a Nextflow pipeline for variant calling using:

- Minimap2 (alignment)
- Samtools (sorting & indexing)
- DeepVariant (variant calling)

## Requirements

- Nextflow
- Singularity / Docker

## Run

nextflow run main.nf -resume

## Benchmarking

Benchmarking is performed using hap.py against GIAB truth set.

Performance metrics include precision, recall, and F1-score for SNP and INDEL detection.

hap.py truth.vcf.gz query.vcf.gz   -f confident_regions.bed   -r GRCh38.fa   -o output_prefix

