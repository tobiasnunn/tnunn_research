#!/bin/bash
#SBATCH --account=scw2160
#SBATCH --job-name=eggnogmapper
#SBATCH --partition=compute           # compute (max resources: 192g; ), highmem (max resources: 384g; 40 threads; 72h)
#SBATCH --ntasks=2                   # Number of tasks
#SBATCH --cpus-per-task=25           # number of cpus per task
#SBATCH --time=02:00:00                # Run time
#SBATCH --mem=45g                     # Memory pool for all cores (in MB: 4096 == 4 GB)
#SBATCH -o /scratch/scw2160/09_logs/eggnogmapper-%A.out
#SBATCH -e /scratch/scw2160/09_logs/eggnogmapper-%A.err
#SBATCH --mail-user=0rtpjri2@anonaddy.me
#SBATCH --mail-type=ALL

eval "$(/apps/languages/anaconda/2024.02/bin/conda shell.bash hook)"
source activate
module load eggnog-mapper/2.1.12

mkdir -p GCF_902706225.1_annotation
mkdir -p GCF_900169365.1_annotation
mkdir -p GCF_900169175.1_annotation

echo "process start" > GCF_902706225.1_start.txt
emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/GCF_902706225.1_n18062v0.1_genomic.fna -o GCF_902706225.1 --output_dir /home/b.tbn23vlc/GCF_902706225.1_annotation/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel --dbmem
emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/GCF_900169365.1_Assembly_BSP239C_genomic.fna -o GCF_900169365.1 --output_dir /home/b.tbn23vlc/GCF_900169365.1_annotation/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel --dbmem
emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/GCF_900169175.1_Assembly_BJEO58_genomic.fna -o GCF_900169175.1 --output_dir /home/b.tbn23vlc/GCF_900169175.1_annotation/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel --dbmem

echo "process end" > GCF_900169175.1_end.txt
