import sys
import csv

def main(file_in, file_out):
    with open(file_in, "r") as f_in, open(file_out, "w+") as f_out:
        reader = csv.reader(f_in, delimiter="\t")
        for i in reader:
            if i[0] == "FID":
                continue
            f_value = float(i[5])
            if f_value >= 0.1:
                fid = str(i[0])
                sid = str(i[1])
                f_out.write(" ".join(map(str, [fid, sid])) + "\n")
    return None


if __name__ == "__main__":
    file_in = sys.argv[1]
    file_out = sys.argv[2]
    main(file_in, file_out)
