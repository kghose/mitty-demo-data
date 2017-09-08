#!/usr/bin/env bash
set -ex

FASTA=../data/human_g1k_v37.fa.gz
FASTQ_PREFIX=HG0019-mq0
BAM=../alignment-accuracy/HG00119-bwa.bam

mitty -v4 debug bam-to-truth ${BAM} 0 HG00019 ${FASTQ_PREFIX}
 
bwa mem ${FASTA} ${FASTQ_PREFIX}-1.fq ${FASTQ_PREFIX}-2.fq | samtools view -bSho temp0.bam
samtools sort temp0.bam > ${FASTQ_PREFIX}.bam 
samtools index ${FASTQ_PREFIX}.bam
 
mitty -v4 debug alignment-analysis process ${FASTQ_PREFIX}.bam ${FASTQ_PREFIX}-lq.txt ${FASTQ_PREFIX}.alignment.npy --fig-prefix ${FASTQ_PREFIX}.alignment --max-d 200   --max-size 50   --plot-bin-size 10
 
#GOD aligner's
mitty -v4 god-aligner ${FASTA} ${FASTQ_PREFIX}-1.fq ${FASTQ_PREFIX}-lq.txt   ${FASTQ_PREFIX}GOD.bam --fastq2 ${FASTQ_PREFIX}-2.fq --threads 2
 
mitty -v4 debug alignment-analysis process ${FASTQ_PREFIX}GOD.bam ${FASTQ_PREFIX}-lq.txt ${FASTQ_PREFIX}GOD.alignment.npy --fig-prefix ${FASTQ_PREFIX}GOD.alignment --max-d 200   --max-size 50   --plot-bin-size 10
