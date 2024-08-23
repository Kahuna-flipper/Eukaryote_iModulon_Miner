#!/bin/bash

# Default values
max_cpus='4'
max_memory='29.GB'
input=''
w=''
outdir=''
fasta=''
gff=''
config_file='custom.config'


# Help message
usage() {
    echo "Usage: $0 [-c max_cpus] [-m max_memory] [-i input] [-w work_dir] [-o outdir] [-f fasta] [-g gff] [-n config_file]"
    exit 1
}

# Parse command-line arguments
while getopts "c:m:i:w:o:f:g:n" opt; do
    case ${opt} in
        c)
            max_cpus=$OPTARG
            ;;
        m)
            max_memory=$OPTARG
            ;;
        i)
            input=$OPTARG
            ;;
        w)
            w=$OPTARG
            ;;
        o)
            outdir=$OPTARG
            ;;
        f)
            fasta=$OPTARG
            ;;
        g)
            gff=$OPTARG
            ;;
        n)
            config_file=$OPTARG
            ;;

    esac
done

# Check if mandatory arguments are provided
if [[ -z "$input" || -z "$w" || -z "$outdir" || -z "$fasta" || -z "$gff" ]]; then
    echo "Error: Missing required arguments."
    usage
fi

# Run the nextflow command
nextflow run nf-core/rnaseq -r 3.14.0 -profile docker \
    --max_cpus "$max_cpus" \
    --max_memory "$max_memory" \
    -w "$w" \
    --input "$input" \
    --outdir "$outdir" \
    --fasta "$fasta" \
    --gff "$gff" \
    -c "$config_file" \
    --skip_biotype_qc \

