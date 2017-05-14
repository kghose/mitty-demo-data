#!/usr/bin/env bash
set -ex

FASTA=../data/human_g1k_v37.fa.gz
FASTQ_PREFIX=../generating-reads/HG00119-reads
BAMIN=../alignment-accuracy/HG00119-bwa.bam
DO_NOT_INDEX=${1}
# Starting this script with the argument --do-not-index will skip the
# BAM file indexing. Due to some bug in pysam the index invocation does
# not work on Linux

BAMOUT=HG00119-bwa-snps.bam
mitty -v4 debug subset-bam \
  ${BAMIN} \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${BAMOUT} \
  --v-range 0 0 \
  --reject-reference-reads \
  --processes 2 ${DO_NOT_INDEX}


BAMOUT=HG00119-bwa-good-del.bam
mitty -v4 debug subset-bam \
  ${BAMIN} \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${BAMOUT} \
  --v-range -10000 -1 \
  --d-range -5 5 \
  --reject-reference-reads \
  --processes 2 ${DO_NOT_INDEX}


BAMOUT=HG00119-bwa-poor-del.bam
mitty -v4 debug subset-bam \
  ${BAMIN} \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${BAMOUT} \
  --v-range -10000 -1 \
  --d-range -5 5 \
  --reject-d-range \
  --reject-reference-reads \
  --processes 2 ${DO_NOT_INDEX}