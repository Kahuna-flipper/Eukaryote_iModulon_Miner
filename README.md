# Eukaryote_iModulon_Miner
Extending the iModulonMiner workflow (https://github.com/SBRG/iModulonMiner) to eukaryotes.

The iModulonMiner workflow uses bowtie to align mostly bacterial rnaseq reads, which will not work well for RNA splicing. This workflow bypassess the second and third  steps of the workflow - Collection of data, processing and aligining reads and QC. Step 4 - Running ICA onwards remains the same (refer to https://github.com/Kahuna-flipper/iModulonMiner/tree/main/4_optICA). Downloading data and QCing is changed because the aligners and workflow used - nfcore rnaseq, have varying i/o formats. 


## Setup

### Docker
We have provided pre-built Docker containers with all necessary software.

To begin, install [Docker](https://docs.docker.com/get-docker/) and [Nextflow](https://www.nextflow.io/).

### Local installation
You can also run each program locally, with all requirements listed in the conda `environment.yml` file. 

## Cite

Please cite the following pre-print: [Mining all publicly available expression data to compute dynamic microbial transcriptional regulatory networks](https://www.biorxiv.org/content/10.1101/2021.07.01.450581v1)

Additionally, also cite nfcore rnaseq using the readme information [here](https://github.com/nf-core/rnaseq/tree/master)
