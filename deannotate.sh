#!/bin/bash

source ./env

while read BATCH; do

  echo "Deannotating ${BATCH}"
  ${BCFTOOLS_EXECUTABLE} annotate -O z -x "INFO,FILTER" --no-version \
  ${BATCHES_SUBSET}/${BATCH}.vcf.gz > \
  ${BATCHES_DEANNOTATED}/${BATCH}.vcf.gz

  echo "Indexing deannotated ${BATCH}"
  ${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BATCHES_DEANNOTATED}/${BATCH}.vcf.gz

done < ${BATCHES}