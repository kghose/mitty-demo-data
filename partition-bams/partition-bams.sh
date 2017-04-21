#!/usr/bin/env bash

set -ex

FASTA=../data/human_g1k_v37.fa.gz
FASTQ_PREFIX=../generating-reads/HG00119-reads

r_value=(1.5 20 200)

for n in 1 2 3

do

BAM=HG00119-bwa${n}.bam

bwa mem \
  -r ${r_value[n]} \
  ${FASTA} \
  ${FASTQ_PREFIX}-corrupt1.fq.gz \
  ${FASTQ_PREFIX}-corrupt2.fq.gz | samtools view -bSho temp.bam
samtools sort temp.bam > ${BAM}
samtools index ${BAM}

mitty -v4 debug alignment-analysis process \
  ${BAM} \
  ${FASTQ_PREFIX}-corrupt-lq.txt \
  ${BAM}.alignment.npy \
  --fig-prefix ${BAM}.alignment \
  --max-d 200 \
  --max-size 50 \
  --plot-bin-size 2

done

mitty -v4 debug partition-bams \
  myderr \
  d_err --threshold 10 \
  --sidecar_in ${FASTQ_PREFIX}-corrupt-lq.txt \
  --bam HG00119-bwa1.bam \
  --bam HG00119-bwa2.bam \
  --bam HG00119-bwa3.bam
