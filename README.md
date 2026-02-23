# hg002-variant-calling-pipeline
Complete variant calling pipeline using Nextflow, SLURM, and Singularity with Clair3 and DeepVariant on HG002 PacBio HiFi data aligned to GRCh38, including benchmarking with GIAB truth set.

## Overview

This project implements an end-to-end production-style variant calling workflow on HPC infrastructure using containerized tools. The pipeline performs:

1. Read alignment using Minimap2
2. BAM sorting and indexing using Samtools
3. Variant calling using Clair3
4. Variant calling using DeepVariant
5. Benchmarking against GIAB HG002 truth set

The workflow is fully reproducible using Nextflow and containerized environments.

---

## Requirements

### Software

* Nextflow ≥ 23
* Singularity / Apptainer
* SLURM workload manager
* Git

### Containers Used

* minimap2 (biocontainers)
* samtools (biocontainers)
* Clair3
* DeepVariant

---

## Dataset

HG002 PacBio HiFi reads were used.

Reference genome:

GRCh38.fa with index:

* GRCh38.fa.fai
* GRCh38.mmi

---

## Pipeline Steps

Pipeline structure:

FASTQ → ALIGN → SORT_INDEX → Variant Calling → Benchmark

---

## Running the Pipeline

### Clone Repository

```bash
git clone https://github.com/FatimaAhmed28/hg002-variant-calling-pipeline.git
cd hg002-variant-calling-pipeline
```

### Configure Parameters

Edit params in `nextflow.config` or `params.config`:

```bash
params {
    fastq = "/path/to/HG002.fastq.gz"
    ref   = "/path/to/GRCh38.fa"
}
```

### Run Pipeline on HPC

```bash
nextflow run main.nf -c nextflow.config -resume
```

---

## Benchmarking

Benchmarking was performed using hap.py comparing variant calls against the Genome in a Bottle (GIAB) HG002 truth dataset.

Performance metrics include:

* Precision
* Recall
* F1-score

Separate evaluation was performed for SNP and INDEL variants within confident genomic regions defined by GIAB.

This benchmarking ensures objective comparison between Clair3 and DeepVariant outputs.

---

## Benchmark Commands

Example benchmarking command:

```bash
hap.py \
  truth.vcf.gz \
  clair3.vcf.gz \
  -f confident_regions.bed \
  -r GRCh38.fa \
  -o clair3_benchmark
```

For DeepVariant:

```bash
hap.py \
  truth.vcf.gz \
  deepvariant.vcf.gz \
  -f confident_regions.bed \
  -r GRCh38.fa \
  -o deepvariant_benchmark
```

---

## SLURM Execution Example

```bash
sbatch --gres=gpu:1 \
       --cpus-per-task=16 \
       --mem=64G \
       run_pipeline.sh
```

---

## Repository Structure

```
hg002-variant-calling-pipeline/
│── main.nf
│── nextflow.config
│── README.md
│
├── ref/
│   ├── GRCh38.fa
│   ├── GRCh38.fa.fai
│   └── GRCh38.mmi
│
├── benchmark/
│   ├── confident_regions.bed
│   └── truth.vcf.gz
│
└── scripts/
```

---

## Results

Both Clair3 and DeepVariant successfully generated variant calls for HG002 aligned to GRCh38.

Benchmarking against GIAB truth set demonstrated high SNP and INDEL detection accuracy within confident genomic regions.

---

## Reproducibility

The pipeline is fully reproducible due to:

* Containerized tools
* Nextflow workflow management
* Version-controlled configuration
* HPC execution via SLURM

---

## Citation

If using this pipeline, please cite:

Genome in a Bottle Consortium
DeepVariant
Clair3

---

## Author

Fatima Ahmed
Advanced Computational Biology Project

---
