#!/usr/bin/env bash

EVCF1=../data/0.9.29.eval.vcf.gz
EVCF2=../data/0.9.32.eval.vcf.gz
OUTPREFIX=fate-29-32

mitty -v4 debug call-fate \
 ${EVCF1} \
 ${EVCF2} \
 - \
 ${OUTPREFIX}-summary.txt | vcf-sort | bgzip -c > ${OUTPREFIX}.vcf.gz
