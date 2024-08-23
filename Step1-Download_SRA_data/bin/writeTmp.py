#!/usr/bin/env python

import argparse
import pandas as pd


def main(sampleID, layout, file):

    try:
        temp_file = pd.read_csv(file, header=None)
    except pd.errors.EmptyDataError:
        temp_file = pd.DataFrame(columns = ["sample", "layout"])

    temp_file.columns = ["sample", "layout"]

    print(temp_file.shape)
    
    toAdd = {"sample": sampleID, "layout": layout}

    temp_file = temp_file.append(toAdd, ignore_index = True)
    temp_file.to_csv(file, header=False, columns=["sample", "layout"], index=False)

    print(temp_file.shape)

if __name__ == '__main__':
     # Argument parsing
    p = argparse.ArgumentParser(description='Takes in list of samples and layouts,'\
        + 'outputs relevant locations of files and samples for nfcore use')
    p.add_argument('sampleID', type=str,
                   help='ID of sample')
    p.add_argument('layout', type=str,
                   help='PAIRED or SINGLE for each sample')
    p.add_argument('file', type=str,
                   help="file to store temp iformation in")
    args = p.parse_args()

    main(args.sampleID,args.layout, args.file)
