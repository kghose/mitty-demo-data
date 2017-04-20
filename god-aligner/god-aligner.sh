#!/usr/bin/env bash

FASTA=../data/human_g1k_v37.fa.gz
FASTQ_PREFIX=../generating-reads/HG00119-reads
GODBAM=HG00119-god.bam

mitty -v4 god-aligner \
  ${FASTA} \
  ${FASTQ_PREFIX}-corrupt1.fq.gz \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${GODBAM} \
  --fastq2 ${FASTQ_PREFIX}-corrupt2.fq.gz \
  --threads 2
