#!/usr/bin/env bash
set -ex

FASTA=../data/human_g1k_v37.fa.gz
FASTQ_PREFIX=../reference-reads/ref-reads
BAM=ref-bwa.bam

bwa mem \
  ${FASTA} \
  ${FASTQ_PREFIX}1.fq.gz \
  ${FASTQ_PREFIX}2.fq.gz | samtools view -bSho temp.bam
samtools sort temp.bam > ${BAM}
samtools index ${BAM}

mitty -v4 debug alignment-analysis process\
  ${BAM} \
  ${FASTQ_PREFIX}-lq.txt \
  ${BAM}.alignment.npy \
  --fig-prefix ${BAM}.alignment \
  --max-d 200 \
  --max-size 50 \
  --plot-bin-size 10