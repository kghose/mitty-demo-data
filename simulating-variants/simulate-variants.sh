#!/usr/bin/env bash
set -ex

FASTA=../data/human_g1k_v37.fa.gz
SAMPLENAME=S0
BED=region.bed
VCF=sim.vcf.gz

mitty -v4 simulate-variants \
  - \
  ${FASTA} \
  ${SAMPLENAME} \
  ${BED} \
  7 \
  --p-het 0.6 \
  --model SNP 0.001 1 1 \
  --model INS 0.0001 10 100 \
  --model DEL 0.0001 10 100 | bgzip -c > ${VCF}

tabix ${VCF}


