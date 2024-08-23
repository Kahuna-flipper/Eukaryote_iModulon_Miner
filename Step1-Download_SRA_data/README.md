# Step 1 - Download SRA data
[Joshua Burrows](https://github.com/jtburrows) wrote these scripts to download all SRA data based on the metadata sheet from Step 1 of the iModulonMiner workflow

cd into the directory with the metadata sheet (example attached here: metadata_yl.tsv), run the following command to run 

nextflow run main.nf -organism 'organisms_name '-profile local (If running locally)

# Running on HPCs

If using an HPC service such as aws batch, create a aws.config file as shown in the conf/aws.config example