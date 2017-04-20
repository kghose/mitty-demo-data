#!/usr/bin/env bash
set -ex

FASTA=../data/human_g1k_v37.fa.gz
FASTQ_PREFIX=../generating-reads/HG00119-reads
BAM=HG00119-bwa.bam

bwa mem \
  ${FASTA} \
  ${FASTQ_PREFIX}-corrupt1.fq.gz \
  ${FASTQ_PREFIX}-corrupt2.fq.gz | samtools view -bSho temp.bam
samtools sort temp.bam > ${BAM}
samtools index ${BAM}

mitty -v4 debug alignment-analysis process\
  ${BAM} \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${BAM}.alignment.npy \
  --fig-prefix ${BAM}.alignment \
  --max-d 200 \
  --max-size 50 \
  --plot-bin-size 10