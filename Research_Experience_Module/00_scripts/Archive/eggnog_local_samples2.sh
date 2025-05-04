#!/bin/bash
#SBATCH --account=scw2160
#SBATCH --job-name=eggnogmapper
#SBATCH --partition=compute           # compute (max resources: 192g; ), highmem (max resources: 384g; 40 threads; 72h)
#SBATCH --ntasks=5                   # Number of tasks
#SBATCH --time=12:00:00                # Run time
#SBATCH --mem=50g                     # Memory pool for all cores (in MB: 4096 == 4 GB)
#SBATCH -o /scratch/scw2160/09_logs/eggnogmapper-%A.out
#SBATCH -e /scratch/scw2160/09_logs/eggnogmapper-%A.err


eval "$(/apps/languages/anaconda/2024.02/bin/conda shell.bash hook)"
source activate
module load eggnog-mapper/2.1.12

mkdir 1Dt2d_new
mkdir 2Dt1e_new
mkdir 2Dt1l_new
echo "process start" > 1Dt2d.txt
emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/flye_asm_1Dt2d_part2.fasta -o 1Dt2d  --output_dir /home/b.tbn23vlc/1Dt2d_new/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel
emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/flye_asm_2Dt1e_part2.fasta -o 2Dt1e  --output_dir /home/b.tbn23vlc/2Dt1e_new/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel
emapper.py -m diamond --itype genome --genepred prodigal -i /home/b.tbn23vlc/fasta_files/flye_asm_2Dt1l_part2.fasta -o 2Dt1l  --output_dir /home/b.tbn23vlc/2Dt1l_new/ --cpu 0 --dmnd_ignore_warnings --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel
echo "process end" > 2Dt1l.txt
