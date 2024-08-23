#!/usr/bin/env python

import argparse
import pandas as pd


def main(csv_input, outdir):

    input_file = pd.read_csv(csv_input, header=True)
    print(input_file.to_string())

    input_file.columns = ["sample", "fastq_1", "fastq_2", ]
    input_file["fastq_1"] = ""
    input_file["fastq_2"] = ""
    input_file["strandedness"] = ""

    if outdir.endswith("/"):
        None
    else:
        outdir = outdir + "/"

    for index, row in input_file.iterrows():
        print(row.to_string())
        if row["layout"] == "PAIRED":
            input_file.at[index, "fastq_1"] = outdir + row["sample"] + "_1.fastq.gz"
            input_file.at[index, "fastq_2"] = outdir + row["sample"] + "_2.fastq.gz"
            input_file.at[index, "strandedness"] = 'auto'
        else:
            input_file.at[index, "fastq_1"] = outdir + row["sample"] + "_1.fastq.gz"
            input_file.at[index, "fastq_2"] = ''
            input_file.at[index, "strandedness"] = 'auto'
    
    column_list = ["sample", "fastq_1", "fastq_2", "strandedness"]
    input_file.to_csv(csv_input, header=True, columns = column_list,index=False)


if __name__ == '__main__':
     # Argument parsing
    p = argparse.ArgumentParser(description='Takes in list of samples and layouts,'\
        + 'outputs relevant locations of files and samples for nfcore use')
    p.add_argument('csv_input', type=str,
                   help='input file of samples and layouts in csv format')
    p.add_argument('outdir', type=str,
                   help='name of outdirectory where files are located')
    args = p.parse_args()

    main(args.csv_input,args.outdir)
