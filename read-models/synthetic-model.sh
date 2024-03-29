#!/usr/bin/env bash
set -ex

MODELNAME=synthetic-model.pkl

mitty create-read-model synth-illumina \
  ${MODELNAME} \
  --read-length 121 \
  --mean-template-length 400 \
  --std-template-length 20 \
  --bq0 30 \
  --k 200 \
  --sigma 5 \
  --comment 'Model created for the demo' \


mitty describe-read-model ${MODELNAME} ${MODELNAME}.png


FASTA=../data/human_g1k_v37.fa.gz
SAMPLEVCF=../data/1kg.20.22.vcf.gz
SAMPLENAME=HG00119
REGION_BED=region.bed
FILTVCF=HG00119-filt.vcf.gz
READMODEL=${MODELNAME}
COVERAGE=1
READ_GEN_SEED=7
FASTQ_PREFIX=HG00119-synth
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
  >(gzip > ${FASTQ_PREFIX}1.fq.gz) \
   ${FASTQ_PREFIX}-lq.txt \
   --fastq2 >(gzip > ${FASTQ_PREFIX}2.fq.gz) \
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
