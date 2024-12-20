# Illumination

This repository contains all the scripts to assemble and annotate genomes from raw Illumina reads.

## Installation

Requirements:
- conda v23.10.0
- mamba v1.5.6\
The following tools installed in their own conda environment:
- snakemake v7.32.4
- R v.4.3.2
  - r-tidyverse
- fastqc v0.11.8
- multiqc v1.6 
- bbmap v39.01 
- seqkit v.2.6.1
- spades v3.15.5
- quast v5.2.0
- checkm v1.2.2 with the database downloaded, decompressed and dearchived. The path to this database must be put in the environment yaml file at the end, so that it is stored in an environment variable.
- gtdb-tk v2.3.2 with the database downloaded and decompressed. The path to this database must be put in the environment yaml file at the end, so that it is stored in an environment variable.

All environment YAML files can be found in /envs.

## Usage

Note: the resources directive in each rule of the snakefile is written for execution on the slurm cluster of UNIL.

1. Create a directory with the following sub-directories:

```
.
│
└─── benchmarks
│   
└─── data
│
└─── logs
│   
└─── results
│
└─── workflow
```

2. Clone this repository in /workflow.
3. Create all conda environments using the YAML files in /workflow/envs.
4. Make sure you have all required databases downloaded and uncompressed (CheckM, GTDB-Tk, DRAM). Add the path to those databases in the yaml file of the environments (checkM, GTDB-Tk) or in the config file (DRAM). Databases for RGI and macsyfinder are installed directly by the snakefile.
5. Add your raw reads (lanes must concatenated into one file per read mate) to /data/raw_reads.
6. Modify the metadata.tsv file to put your samples and indicate which adapter they contain. If you don't know, you can fill this column later when you have the first MultiQC output.
7. Symlink the scratch to the results directory with the following command (don't forget to replace `<rootdir>` and `<username>`):

```
cd <rootdir>/workflow/scripts
ln -s /scratch/<username> ../../results/scratch
```

8. Activate your snakemake conda environment and run each part of the pipeline written in different snakefiles.

If snakemake raises issues with conflicting versions when creating the conda environments, it helps to (temporarily) set the channel priority to flexible.

Check points requiring manual input:
- after running fastqc, add column 'adapter' to metadata.tsv file indicating which adapter was found in each sample
- after running the genomes QC until CheckM, add column 'include_downstream' to indicate if you wish to pursue the analysis of the genome (1) or not (0). If the genome is less than 95% complete (CheckM) it might not be worth it.

## Publication and authors

Pipeline built by Méline Garcia.