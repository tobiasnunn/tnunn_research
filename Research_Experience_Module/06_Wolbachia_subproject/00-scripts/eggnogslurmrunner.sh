#!/bin/bash
#SBATCH --account=scw2160
#SBATCH --job-name=eggnogmapper
#SBATCH --partition=compute           # compute (max resources: 192g; ), highmem (max resources: 384g; 40 threads; 72h)
#SBATCH --ntasks=2                   # Number of tasks
#SBATCH --cpus-per-task=25          # number of cpus per task
#SBATCH --time=02:00:00                # Run time
#SBATCH --mem=45g                     # Memory pool for all cores (in MB: 4096 == 4 GB)
#SBATCH -o /scratch/scw2160/09_logs/eggnogmapper-%A.out
#SBATCH -e /scratch/scw2160/09_logs/eggnogmapper-%A.err
#SBATCH --mail-user=0rtpjri2@anonaddy.me
#SBATCH --mail-type=ALL

accession=$1
filename=$2

mkdir -p ${accession}_annotation


eval "$(/apps/languages/anaconda/2024.02/bin/conda shell.bash hook)"
source activate
module load eggnog-mapper/2.1.12

emapper.py -m diamond --itype genome --genepred prodigal --override -i /home/b.tbn23vlc/fasta_files/${filename} -o ${accession} --output_dir /home/b.tbn23vlc/${accession}_annotation/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel --dbmem

cp /home/b.tbn23vlc/${accession}_annotation/${accession}.emapper.annotations.xlsx /home/b.tbn23vlc/eggnog_annotations/
