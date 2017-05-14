#!/usr/bin/env bash
set -ex

FASTA=../data/human_g1k_v37.fa.gz
FASTQ_PREFIX=../generating-reads/HG00119-reads
BAMIN=../alignment-accuracy/HG00119-bwa.bam

BAMOUT=HG00119-bwa-snps.bam
mitty -v4 debug subset-bam \
  ${BAMIN} \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${BAMOUT} \
  --v-range 0 0 \
  --reject-reference-reads \
  --processes 2


BAMOUT=HG00119-bwa-pool-del.bam
mitty -v4 debug subset-bam \
  ${BAMIN} \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${BAMOUT} \
  --v-range -10000 -1 \
  --d-range -5 5 \
  --reject-d-range \
  --reject-reference-reads \
  --processes 2
