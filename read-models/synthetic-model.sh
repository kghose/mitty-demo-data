#!/usr/bin/env bash

MODELNAME=synthetic-model.pkl

mitty create-read-model synth-illumina \
  ${MODELNAME} \
  --read-length 121 \
  --mean-template-length 400 \
  --std-template-length 20 \
  --bq0 30 \
  --k 200 \
  --sigma 5 \
  --comment 'Model created for the demo' \


mitty describe-read-model ${MODELNAME} ${MODELNAME}.png