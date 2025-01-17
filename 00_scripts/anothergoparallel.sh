#!/bin/bash
#SBATCH --account=scw2160
#SBATCH --job-name=eggnogmapper
#SBATCH --partition=compute           # compute (max resources: 192g; ), highmem (max resources: 384g; 40 threads; 72h)
#SBATCH --ntasks=5                   # Number of tasks
#SBATCH --cpus-per-task=10           # number of cpus per task
#SBATCH --time=12:00:00                # Run time
#SBATCH --mem=50g                     # Memory pool for all cores (in MB: 4096 == 4 GB)
#SBATCH -o /scratch/scw2160/09_logs/eggnogmapper-%A.out
#SBATCH -e /scratch/scw2160/09_logs/eggnogmapper-%A.err
#SBATCH --mail-user=0rtpjri2@anonaddy.me
#SBATCH --mail-type=ALL


eval "$(/apps/languages/anaconda/2024.02/bin/conda shell.bash hook)"
source activate
module load eggnog-mapper/2.1.12

#mkdir GCF_900done258505.1_new
#mkdir GCF_003711805.1_new
mkdir GCF_014204755.1_new
#mkdir GCF_005490785.1_new
#mkdir GCF_015209585.1_new
echo "process start" > eggnog_start2.txt
emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/GCF_014204755.1_ASM1420475v1_genomic.fna -o GCF_014204755.1 --output_dir /home/b.tbn23vlc/GCF_014204755.1_new/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel --dbmem
#emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/GCA_019118275.1_ASM1911827v1_genomic.fna -o GCA_019118275.1 --output_dir /home/b.tbn23vlc/GCA_019118275.1_new/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel --dbmem
#emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/GCF_000225825.1_ASM22582v2_genomic.fna -o GCF_000225825.1 --output_dir /home/b.tbn23vlc/GCF_000225825.1_new/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel --dbmem
#emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/GCF_005490785.1_ASM549078v1_genomic.fna -o GCF_005490785.1 --output_dir /home/b.tbn23vlc/GCF_005490785.1_new/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel --dbmem
#emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/GCF_015209585.1_ASM1520958v1_genomic.fna -o GCF_015209585.1 --output_dir /home/b.tbn23vlc/GCF_015209585.1_new/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel --dbmem
echo "process end" > eggnog__end2.txt
