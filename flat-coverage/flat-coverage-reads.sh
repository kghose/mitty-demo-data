#!/usr/bin/env bash
set -ex

FASTA=../data/human_g1k_v37.fa.gz
SAMPLEVCF=../data/1kg.20.22.vcf.gz
SAMPLENAME=HG00119
REGION_BED=region.bed
FILTVCF=HG00119-filt.vcf.gz
READMODEL=1kg-pcr-free.pkl
COVERAGE=30
READ_GEN_SEED=7
FASTQ_PREFIX=HG00119-flat-cov
READ_CORRUPT_SEED=8
BAM=HG00119-flat-cov-bwa.bam
GODBAM=HG00119-flat-cov-god.bam

mitty -v4 filter-variants \
  ${SAMPLEVCF} \
  ${SAMPLENAME} \
  ${REGION_BED} \
  - \
  2> vcf-filter.log | bgzip -c > ${FILTVCF}

tabix -p vcf ${FILTVCF}

mitty -v4 generate-reads \
  ${FASTA} \
  ${FILTVCF} \
  ${SAMPLENAME} \
  ${REGION_BED} \
  ${READMODEL} \
  ${COVERAGE} \
  ${READ_GEN_SEED} \
  >(gzip > ${FASTQ_PREFIX}1.fq.gz) \
   ${FASTQ_PREFIX}-lq.txt \
   --fastq2 >(gzip > ${FASTQ_PREFIX}2.fq.gz) \
   --flat-coverage \
   --threads 2

mitty -v4 corrupt-reads \
  ${READMODEL} \
  ${FASTQ_PREFIX}1.fq.gz >(gzip > ${FASTQ_PREFIX}-corrupt1.fq.gz) \
  ${FASTQ_PREFIX}-lq.txt \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${READ_CORRUPT_SEED} \
  --fastq2-in ${FASTQ_PREFIX}2.fq.gz \
  --fastq2-out >(gzip > ${FASTQ_PREFIX}-corrupt2.fq.gz) \
  --threads 2


bwa mem \
  ${FASTA} \
  ${FASTQ_PREFIX}-corrupt1.fq.gz \
  ${FASTQ_PREFIX}-corrupt2.fq.gz | samtools view -bSho temp.bam
samtools sort temp.bam -o ${BAM}
samtools index ${BAM}


mitty -v4 god-aligner \
  ${FASTA} \
  ${FASTQ_PREFIX}-corrupt1.fq.gz \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${GODBAM} \
  --fastq2 ${FASTQ_PREFIX}-corrupt2.fq.gz \
  --threads 2


samtools depth ${BAM} > bwa.coverage
samtools depth ${GODBAM} > god.coverage