#!/bin/bash

source ./env

while read BATCH; do

  # necessary to use an exclude tag `-V` since the include tag `-v snps` removes markers with empty ALT (ALT=".")
  # after allele trimming
  echo "Performing normalization on ${BATCH}"
  ${BCFTOOLS_EXECUTABLE} view --no-update --no-version -O u --threads ${THREADS} \
  --trim-alt-alleles --no-update --no-version ${BATCHES_DEANNOTATED}/${BATCH}.vcf.gz | \
  ${BCFTOOLS_EXECUTABLE} norm -c x -f ${HG38FASTA} -O u --threads ${THREADS} | \
  ${BCFTOOLS_EXECUTABLE} view --no-update --no-version -V indels,mnps,other \
  --threads ${THREADS} -O z > ${BATCHES_NORMED}/${BATCH}.vcf.gz

  echo "Indexing normalized ${BATCH}"
  ${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BATCHES_NORMED}/${BATCH}.vcf.gz

done < ${BATCHES}