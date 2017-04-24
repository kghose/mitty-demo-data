#!/usr/bin/env bash

set -ex

FASTA=../data/human_g1k_v37.fa.gz
VCF=human-m-ref.vcf.gz
SAMPLENAME=ref
REGION_BED=region-m.bed
READMODEL=1kg-pcr-free.pkl
COVERAGE=30
READ_GEN_SEED=7
FASTQ_PREFIX=ref-reads

mitty -v4 generate-reads \
  ${FASTA} \
  ${VCF} \
  ${SAMPLENAME} \
  ${REGION_BED} \
  ${READMODEL} \
  ${COVERAGE} \
  ${READ_GEN_SEED} \
  >(gzip > ${FASTQ_PREFIX}1.fq.gz) \
   ${FASTQ_PREFIX}-lq.txt \
   --fastq2 >(gzip > ${FASTQ_PREFIX}2.fq.gz) \
   --threads 2