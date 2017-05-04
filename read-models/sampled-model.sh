#!/usr/bin/env bash
set -ex

BAM=../data/sample.bam
MODELNAME=sampled-model.pkl

mitty -v4 create-read-model bam2illumina \
  --every 10 \
  --min-mq 20 \
  -t 2 \
  --max-bp 300 \
  --max-tlen 1000 \
  ${BAM} \
  ${MODELNAME} \
  'Sampled model created for the demo'

mitty describe-read-model ${MODELNAME} ${MODELNAME}.png
