#!/usr/bin/env bash

EVCF=../data/0.9.29.eval.vcf.gz
CSV=0.9.29.eval.data.csv
FIG=caller-report-example.png

mitty -v4 debug variant-call-analysis process \
 ${EVCF} \
 ${CSV} \
 --max-size 75 \
 --fig-file ${FIG} \
 --plot-bin-size 5 \
 --title 'Example call analysis plot'
