nextflow.enable.dsl=2

params {
    fastq = "data/HG002.fastq.gz"
    ref   = "ref/GRCh38.fa"
}

process ALIGN {
    container "docker://quay.io/biocontainers/minimap2:2.28--he4a0461_0"
    cpus 16
    memory '32 GB'

    input:
    path fastq
    path ref

    output:
    path "aligned.sam.gz"

    script:
    """
    minimap2 -t ${task.cpus} -ax map-hifi ${ref} ${fastq} | gzip -c > aligned.sam.gz
    """
}

process SORT_INDEX {
    container "docker://quay.io/biocontainers/samtools:1.18--h50ea8bc_1"
    cpus 8
    memory '32 GB'

    input:
    path sam

    output:
    path "aligned.bam"

    script:
    """
    gunzip -c ${sam} | samtools sort -@ ${task.cpus} -o aligned.bam
    samtools index -@ ${task.cpus} aligned.bam
    """
}

process DEEPVARIANT {
    container "docker://google/deepvariant:latest"
    cpus 8
    memory '40 GB'

    input:
    path bam
    path ref

    output:
    path "deepvariant.vcf.gz"

    script:
    """
    /opt/deepvariant/bin/run_deepvariant         --model_type PACBIO         --ref ${ref}         --reads ${bam}         --output_vcf deepvariant.vcf.gz         --num_shards ${task.cpus}
    """
}

workflow {
    fastq = file(params.fastq)
    ref   = file(params.ref)

    sam = ALIGN(fastq, ref)
    bam = SORT_INDEX(sam)

    DEEPVARIANT(bam, ref)
}
