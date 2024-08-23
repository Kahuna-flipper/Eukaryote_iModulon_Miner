# Step 2 - Process and align reads
This step proccesses all downloaded reads in step 1 and performs RNAseq calculations using nfcore rnaseq. The workflow requires the generated nocore_samples sheet that is downloaded in the first step. The workflow also requires the location of downloaded fna and gff files for alignment. Make a config file as shown in the example in custom.config and run the command below to run the workflow to get a final tpm file along with multiqc reports.

./run_nfcore_rnaseq.sh -c 4 -m 29.GB -i location/of/nfcore_samples_full.csv -w /location/of/working/directory -o /location/of/folder/for/outputs -f /location/of/genome.fna -g /location/of/genome.gff -n custom.config


# Running on HPCs

If using an HPC service such as aws batch, create a aws.config file as shown in the aws.config example. In this case all directories including location of nfcore_samples_full.csv, output storage location and location of fna and gff files have to be aws s3 directories

Generate a aws config file as shown in aws.config and run the following command 

./run_nfcore_rnaseq.sh -c 4 -m 29.GB -i //s3:location/of/nfcore_samples_full.csv -w //s3:/location/of/working/directory -o //s3:/location/of/folder/for/outputs -f //s3:/location/of/genome.fna -g //s3:/location/of/genome.gff -n custom.config