#!/bin/bash

source ./env

${BCFTOOLS_EXECUTABLE} merge -m both --threads ${THREADS} -O z \
${BATCHES_MERGED_BY_ARRAY}/${ARRAY_DTC}.vcf.gz \
${BATCHES_MERGED_BY_ARRAY}/${ARRAY_ERA}.vcf.gz \
${BATCHES_MERGED_BY_ARRAY}/${ARRAY_ORI}.vcf.gz > \
${BATCHES_MERGED}/raw.vcf.gz