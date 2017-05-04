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
FASTQ_PREFIX=HG00119-unpaired-reads
READ_CORRUPT_SEED=8

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
  >(gzip > ${FASTQ_PREFIX}.fq.gz) \
   ${FASTQ_PREFIX}-lq.txt \
   --unpair \
   --threads 2

mitty -v4 corrupt-reads \
  ${READMODEL} \
  ${FASTQ_PREFIX}.fq.gz >(gzip > ${FASTQ_PREFIX}-corrupt.fq.gz) \
  ${FASTQ_PREFIX}-lq.txt \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${READ_CORRUPT_SEED} \
  --threads 2
