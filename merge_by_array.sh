#!/bin/bash

source ./env

echo "Preparing merge lists"
find ${BATCHES_NORMED} | grep -w -f ${METADIR}/batches_${ARRAY_DTC} | grep -v "tbi" > ${METADIR}/paths_${ARRAY_DTC}
find ${BATCHES_NORMED} | grep -w -f ${METADIR}/batches_${ARRAY_ERA} | grep -v "tbi" > ${METADIR}/paths_${ARRAY_ERA}
find ${BATCHES_NORMED} | grep -w -f ${METADIR}/batches_${ARRAY_ORI} | grep -v "tbi" > ${METADIR}/paths_${ARRAY_ORI}
find ${BATCHES_NORMED} | grep -w -f ${METADIR}/batches_${ARRAY_COREEX} | grep -v "tbi" > ${METADIR}/paths_${ARRAY_COREEX}
find ${BATCHES_NORMED} | grep -w -f ${METADIR}/batches_${ARRAY_COREEXB} | grep -v "tbi" > ${METADIR}/paths_${ARRAY_COREEXB}
find ${BATCHES_NORMED} | grep -w -f ${METADIR}/batches_${ARRAY_ATLAS} | grep -v "tbi" > ${METADIR}/paths_${ARRAY_ATLAS}
find ${BATCHES_NORMED} | grep -w -f ${METADIR}/batches_${ARRAY_ALBIOGENCO} | grep -v "tbi" > ${METADIR}/paths_${ARRAY_ALBIOGENCO}

echo "Performing ${ARRAY_DTC} merge"
${BCFTOOLS_EXECUTABLE} merge -m both --threads ${THREADS} -O z \
-l ${METADIR}/paths_${ARRAY_DTC} > ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_DTC}.vcf.gz
${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_DTC}.vcf.gz

echo "Performing ${ARRAY_ERA} merge"
${BCFTOOLS_EXECUTABLE} merge -m both --threads ${THREADS} -O z \
-l ${METADIR}/paths_${ARRAY_ERA} > ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_ERA}.vcf.gz
${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_ERA}.vcf.gz

echo "Performing ${ARRAY_ORI} merge"
${BCFTOOLS_EXECUTABLE} merge -m both --threads ${THREADS} -O z \
-l ${METADIR}/paths_${ARRAY_ORI} > ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_ORI}.vcf.gz
${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_ORI}.vcf.gz

echo "Performing ${ARRAY_COREEX} merge"
${BCFTOOLS_EXECUTABLE} merge -m both --threads ${THREADS} -O z \
-l ${METADIR}/paths_${ARRAY_COREEX} > ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_COREEX}.vcf.gz
${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_COREEX}.vcf.gz

echo "Performing ${ARRAY_COREEXB} merge"
${BCFTOOLS_EXECUTABLE} merge -m both --threads ${THREADS} -O z \
-l ${METADIR}/paths_${ARRAY_COREEXB} > ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_COREEXB}.vcf.gz
${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_COREEXB}.vcf.gz

echo "Performing ${ARRAY_ATLAS} merge"
${BCFTOOLS_EXECUTABLE} merge -m both --threads ${THREADS} -O z \
-l ${METADIR}/paths_${ARRAY_ATLAS} > ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_ATLAS}.vcf.gz
${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_ATLAS}.vcf.gz

echo "Performing ${ARRAY_ALBIOGENCO} merge"
${BCFTOOLS_EXECUTABLE} merge -m both --threads ${THREADS} -O z \
-l ${METADIR}/paths_${ARRAY_ALBIOGENCO} > ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_ALBIOGENCO}.vcf.gz
${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BATCHES_MERGED_BY_ARRAY}/${ARRAY_ALBIOGENCO}.vcf.gz

