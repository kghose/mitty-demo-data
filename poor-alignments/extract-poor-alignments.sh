#!/usr/bin/env bash
set -ex

FASTA=../data/human_g1k_v37.fa.gz
FASTQ_PREFIX=../generating-reads/HG00119-reads
BAMIN=../alignment-accuracy/HG00119-bwa.bam
BAMOUT=HG00119-bwa-poor.bam

mitty -v4 debug poor-alignments \
  ${BAMIN} \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${BAMOUT} \
  5 \
  --processes 2 \
  --no-sort