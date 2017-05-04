#!/usr/bin/env bash
set -ex

get_reference () {
ftp ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz
gunzip -c human_g1k_v37.fasta.gz | bgzip -c > human_g1k_v37.fa.gz
rm human_g1k_v37.fasta.gz
bwa index human_g1k_v37.fa.gz
}


get_1000g_sample () {
ftp ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr20.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
mv ALL.chr20.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz all.chr20.vcf.gz
ftp ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
mv ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz all.chr22.vcf.gz
cat all.chr20.vcf.gz all.chr22.vcf.gz > 1kg.20.22.vcf.gz
rm all.chr20.vcf.gz all.chr22.vcf.gz
tabix 1kg.20.22.vcf.gz
}


get_sample_BAM () {
ftp ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data/HG00096/alignment/HG00096.chrom20.ILLUMINA.bwa.GBR.low_coverage.20120522.bam
mv HG00096.chrom20.ILLUMINA.bwa.GBR.low_coverage.20120522.bam sample.bam
ftp ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data/HG00096/alignment/HG00096.chrom20.ILLUMINA.bwa.GBR.low_coverage.20120522.bam.bai
mv HG00096.chrom20.ILLUMINA.bwa.GBR.low_coverage.20120522.bam.bai sample.bam.bai
}

# Run this script at the start to collect all the necessary data files
# Comment out lines you do not need (e.g. you may have a reference already)

get_reference
get_1000g_sample
get_sample_BAM