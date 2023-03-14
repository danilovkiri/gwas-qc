#!/bin/bash

# create binaries from raw VCF file
${PLINK_EXECUTABLE} --vcf ${BATCHES_MERGED}/raw.vcf.gz --make-bed --keep-allele-order \
--out ${BINARY}/raw --impute-sex y-only 0 1

# collect stats
${PLINK_EXECUTABLE} --bfile ${BINARY}/raw --het --out ${RAW_STATS}/raw_het_stats
${PLINK_EXECUTABLE} --bfile ${BINARY}/raw --hardy midp --out ${RAW_STATS}/raw_hwe_stats
${PLINK_EXECUTABLE} --bfile ${BINARY}/raw --missing --out ${RAW_STATS}/raw_missing_stats

# filter raw_het_stats.het and extract a list of FIDs and within-family IDs which have HET F value higher than 0.1
${EXT_SCRIPTS}/plinkTableToTsv.sh ${RAW_STATS}/raw_het_stats.het > ${RAW_STATS}/raw_het_stats.het.tsv
python3 ${EXT_SCRIPTS}/select_FID_ID_failing_het.py ${RAW_STATS}/raw_het_stats.het.tsv ${RAW_STATS}/samples_failing_het.txt

# filter by HWE, heterozygosity and per-marker missing rate
${PLINK_EXECUTABLE} --bfile ${BINARY}/raw --hwe 0.000001 midp --geno 0.1 \
--remove ${RAW_STATS}/samples_failing_het.txt --make-bed --out ${BINARY}/prefiltered

# filter by IBD
${PLINK2_EXECUTABLE} --bfile ${BINARY}/prefiltered --make-king triangle bin --out ${BINARY}/prefiltered_king_data
${PLINK2_EXECUTABLE} --bfile ${BINARY}/prefiltered --king-cutoff ${BINARY}/prefiltered_king_data 0.015625 \
--out ${BINARY}/ibd_analysis_results
${PLINK2_EXECUTABLE} --bfile ${BINARY}/prefiltered --remove ${BINARY}/ibd_analysis_results.king.cutoff.out.id \
--make-bed --out ${BINARY}/filtered

# in-study PCA
${PLINK_EXECUTABLE} --bfile ${BINARY}/filtered --pca tabs header --out ${BINARY}/filtered_PCs

# prepare 1KG reference for PCA (use previously filtered by MAC >= 5) GRCh38-aligned
## make binary from 1KG combined VCF
${PLINK2_EXECUTABLE} --vcf ${ONEKG}/All.1kg.2019.filtered.vcf.gz --threads ${THREADS} --make-bed --keep-allele-order \
--max-alleles 2 --min-alleles 2 --rm-dup exclude-all --snps-only just-acgt --autosome --out ${ONEKG}/1KG
## find consensus variants shared between the study and 1KG datasets
python3 ${EXT_SCRIPTS}/get_intersected_variants_from_bims.py ${BINARY}/filtered.bim ${ONEKG}/1KG.bim \
${PCA_1KG_STUDY}/consensus_1KG_variants.txt
## extract subsets from study and 1KG datasets for further merging
${PLINK2_EXECUTABLE} --bfile ${ONEKG}/1KG --extract ${PCA_1KG_STUDY}/consensus_1KG_variants.txt --make-bed \
--out ${ONEKG}/1KG_subset
${PLINK2_EXECUTABLE} --bfile ${BINARY}/filtered --extract ${PCA_1KG_STUDY}/consensus_1KG_variants.txt --make-bed \
--out ${BINARY}/filtered_subset
## merge extracted 1KG and study subsets
${PLINK_EXECUTABLE} --bfile ${ONEKG}/1KG_subset --bmerge ${BINARY}/filtered_subset \
--threads ${THREADS} --keep-allele-order --make-bed --out ${PCA_1KG_STUDY}/1KG_study_merge

# 1KG-vs-study PCA
${PLINK_EXECUTABLE} --bfile ${PCA_1KG_STUDY}/1KG_study_merge --pca tabs header --out ${PCA_1KG_STUDY}/1kg_vs_study_PCs

# make VCF for imputation
## make autosomal VCF
${PLINK_EXECUTABLE} --bfile ${BINARY}/filtered --recode vcf-iid --output-chr chrM --autosome --out ${BINARY}/filtered
bgzip -@ ${THREADS} ${BINARY}/filtered.vcf
${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BINARY}/filtered.vcf.gz
## make chrX VCF
${PLINK_EXECUTABLE} --bfile ${BINARY}/filtered --recode vcf-iid --output-chr chrM --chr X,XY --out ${BINARY}/filtered_chrX
bgzip -@ ${THREADS} ${BINARY}/filtered_chrX.vcf
${BCFTOOLS_EXECUTABLE} index --tbi --threads ${THREADS} ${BINARY}/filtered_chrX.vcf.gz