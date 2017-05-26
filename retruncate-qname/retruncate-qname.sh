#!/usr/bin/env bash
set -ex

FASTA=../data/human_g1k_v37.fa.gz
ORIGINAL_FQ_PFX=../generating-reads/HG00119-reads
TRUNCATED_FQ_PFX=truncated-fq

ORIGINAL_BAM=../alignment-accuracy/HG00119-bwa.bam
TRUNCATED_BAM=truncated-bam.bam

# Truncate FASTQ
mitty -v4 utils retruncate-qname \
  ${ORIGINAL_FQ_PFX}1.fq.gz \
  ${ORIGINAL_FQ_PFX}-lq.txt \
  >(gzip > ${TRUNCATED_FQ_PFX}1.fq.gz) \
  ${TRUNCATED_FQ_PFX}-lq.txt \
  --truncate-to 200 &

mitty -v4 utils retruncate-qname \
  ${ORIGINAL_FQ_PFX}2.fq.gz \
  ${ORIGINAL_FQ_PFX}-lq.txt \
  >(gzip > ${TRUNCATED_FQ_PFX}2.fq.gz) \
  /dev/null \
  --truncate-to 200 &

wait

# Tests to see if our truncated FASTQ is working
bwa mem \
  ${FASTA} \
  ${TRUNCATED_FQ_PFX}1.fq.gz \
  ${TRUNCATED_FQ_PFX}2.fq.gz | samtools view -bSho temp.bam
samtools sort temp.bam > ${TRUNCATED_FQ_PFX}.bam
samtools index ${TRUNCATED_FQ_PFX}.bam

mitty -v4 debug alignment-analysis process\
  ${TRUNCATED_FQ_PFX}.bam \
  ${TRUNCATED_FQ_PFX}-lq.txt \
  ${TRUNCATED_FQ_PFX}.bam.alignment.npy \
  --fig-prefix ${TRUNCATED_FQ_PFX}.bam.alignment \
  --max-d 200 \
  --max-size 50 \
  --plot-bin-size 10


# Truncate BAM
mitty -v4 utils retruncate-qname \
  ${ORIGINAL_BAM} \
  ${ORIGINAL_FQ_PFX}-corrupt-lq.txt \
  ${TRUNCATED_BAM} \
  ${TRUNCATED_BAM}-lq.txt \
  --truncate-to 200

samtools index ${TRUNCATED_BAM}

# Sanity check
samtools view -c ${ORIGINAL_BAM}
samtools view -c ${TRUNCATED_BAM}

# Tests to see if our truncated BAM is working
mitty -v4 debug alignment-analysis process\
  ${TRUNCATED_BAM} \
  ${TRUNCATED_BAM}-lq.txt \
  ${TRUNCATED_BAM}.alignment.npy \
  --fig-prefix ${TRUNCATED_BAM}.alignment \
  --max-d 200 \
  --max-size 50 \
  --plot-bin-size 10

