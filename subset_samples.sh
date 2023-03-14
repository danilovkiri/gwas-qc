#!/bin/bash

source ./env

while IFS=' ' read -r BATCH BCS; do

  echo "Subsetting samples from ${BATCH} with samples ${BCS}"
  ${BCFTOOLS_EXECUTABLE} view -O z --threads ${THREADS} -s ${BCS} \
  --force-samples --no-update --no-version \
  ${BATCHES_SOURCE}/${BATCH}.vcf.gz > ${BATCHES_SUBSET}/${BATCH}.vcf.gz

  echo "Indexing sample subset ${BATCH}"
  ${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BATCHES_SUBSET}/${BATCH}.vcf.gz

done < ${BATCHES_AND_SAMPLES}