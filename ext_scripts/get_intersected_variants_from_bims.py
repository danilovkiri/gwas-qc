import sys
import csv

def main(file_bim_1, file_bim_2, file_out):
    set1 = dict()
    with open(file_bim_1, "r") as f_in:
        reader = csv.reader(f_in, delimiter="\t")
        for i in reader:
            variantID = str(i[1])
            if variantID == ".":
                continue
            else:
                allele1 = str(i[4])
                allele2 = str(i[5])
                set1[variantID] = {"allele1": allele1, "allele2": allele2}

    with open(file_bim_2, "r") as f_in, open(file_out, "w+") as f_out:
        reader = csv.reader(f_in, delimiter="\t")
        for i in reader:
            variantID = str(i[1])
            if variantID == ".":
                continue
            else:
                if variantID in set1:
                    subset1 = set1[variantID]
                    allele1 = str(i[4])
                    allele2 = str(i[5])
                    if allele1 == subset1["allele1"] and allele2 == subset1["allele2"]:
                        f_out.write(variantID + "\n")

    return None


if __name__ == "__main__":
    file_bim_1 = sys.argv[1]
    file_bim_2 = sys.argv[2]
    file_out = sys.argv[3]
    main(file_bim_1, file_bim_2, file_out)
