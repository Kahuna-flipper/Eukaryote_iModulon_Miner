#!/usr/bin/env nextflow

/*
Downloading fastq files to a local or cloud directory

The below processes will download the fastq files to a specified directory by
the user for the purpose of future use, such as in an nfcore pipeline.

The reesults will also be compiled into a list of experiment name related to 
each SRA accession as well as its path in the specified outdir for the pipeline
*/


nextflow.enable.dsl=1

@Grab('com.xlson.groovycsv:groovycsv:1.3')
import static com.xlson.groovycsv.CsvParser.parseCsv

//Ensure params.outdir ends with a "/"
if(params.outdir[-1] != "/"){
    outdir = "${params.outdir}" + "/"
}
else{
    outdir = "${params.outdir}"
}


//Below code is adapted from modulome nextflow code by Anand Sastry
// Ensure file exists
File csv = new File(params.metadata)
assert(csv.exists())

// Load metadata file
csv_text = file(params.metadata).text
csv_data = parseCsv(csv_text,separator:'\t')

// Loop through rows
sample_ids = csv_data.collect { row ->
    
    // Ensure that Layout is either SINGLE or PAIRED
    assert((row['LibraryLayout'] == 'SINGLE') ||
           (row['LibraryLayout'] == 'PAIRED'))
    
    // Save Experiment ID in sample_ids
    row['Experiment']
}

// Ensure that sample IDs are unique
assert(sample_ids.clone().unique().size() == sample_ids.size())

Channel
    .fromPath(params.metadata,checkIfExists:true)
    .splitCsv(header:true,sep:'\t')
    .branch { row ->
        sra: row.R1 == ""
            return tuple(row.Experiment, 
                         row.LibraryLayout, 
                         row.Platform,
                         row.Swift,
                         row.Run)            
    }
    .set{ metadata_ch }


/*
Ensure csv file for processing is not already present. If it is, the program
will not run. Please rename an older file or delete it to distinguish between
the current process and any relevant older files from previous downloads.
*/
csvFile = file(params.csv_outfile)
assert(!csvFile.exists())
csvFile.text = ""

/*
This process will download the fastq files from the SRA, then gzip them 
for memory efficiency. It will delete the unzipped files from the work
directory and then publish the files to the specified outdirectory.
*/
process downloadSRA {

    label 'fastq'
    label 'medium'
    

    publishDir "${outdir}", mode: 'move', pattern: '*.fastq.gz'

    maxRetries 1
    errorStrategy  { task.attempt <= maxRetries  ? 'retry' : 'ignore' }

    input: 
    tuple sample_id, layout, platform, swift, run_ids from metadata_ch.sra

     output:
     file("${sample_id}_[12].fastq.gz")
     tuple sample_id, layout into sample_name_ch
    
    script:
    """
    for run in ${run_ids.replace(';',' ')}; do
        prefetch --max-size 10000000000000 \$run
        fasterq-dump \$run -e ${task.cpus}
    done
    
    if [ "${layout}" = "SINGLE" ]; then
        pigz -c *.fastq > ${sample_id}_1.fastq.gz
    else
        pigz -c *_1.fastq > ${sample_id}_1.fastq.gz
        pigz -c *_2.fastq > ${sample_id}_2.fastq.gz
    fi
    """
    
}

/*
Intermediary process to take each sample which successfully downloaded and
put their accessions and layouts into a temporary csv file which will be 
processed to create the final csv which can be used for nf-core processing
*/
process create_tmp_file {
    label 'small'
    label 'python'

    input:
    val sample from sample_name_ch.collect(flat: false).ifEmpty([])

    output:
    val sample into final_ch

    script:
    csvFile = file(params.csv_outfile)
    assert(csvFile.exists())
    csvFile.append("sample,fastq_1,fastq_2,strandedness\n")
    for(element in sample){
        if(element[1] =="PAIRED"){
            csvFile.append("${element[0]},${outdir}${element[0]}_1.fastq.gz,${outdir}${element[0]}_2.fastq.gz,auto\n")
        }
        else{
            csvFile.append("${element[0]},${outdir}${element[0]}_1.fastq.gz,,auto\n")
        }
    }
    """
    echo "Completed updating file"
    """
}
