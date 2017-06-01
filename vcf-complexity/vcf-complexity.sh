#!/usr/bin/env bash
set -ex

VCFIN=../data/0.9.29.eval.vcf.gz
VCFOUT=0.9.29.eval.cplx.vcf
REF=../data/human_g1k_v37.fa.gz
BG=../data/map100.bg.pkl

mitty -v4 utils vcf-complexity \
  ${VCFIN} \
  ${VCFOUT} \
  ${REF} \
  ${BG} \
 --window-size 100