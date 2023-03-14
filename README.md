# GWAS genetic data processing QC

## Usage

Set the paths and parameters in the [.env](./.env) file prior to running and source it. The necessary files are
contained in the [metdata](./metadata) directory, amend as you see fit.

Run the scripts in the following order:

1. [subset_samples.sh](./subset_samples.sh)
2. [deannotate.sh](./deannotate.sh)
3. [trim_norm_remove_mnvs_indels.sh](./trim_norm_remove_mnvs_indels.sh)
4. [merge_by_array.sh](./merge_by_array.sh)
5. [merge_all.sh](./merge_all.sh)
6. [plink_qc.sh](./plink_qc.sh)