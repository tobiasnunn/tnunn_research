#!/bin/bash
#SBATCH --account=scw2160
#SBATCH --job-name=checkMtreeQA5
#SBATCH --partition=compute           # compute (max resources: 192g; ), highmem (max resources: 384g; 40 threads; 72h)
#SBATCH --ntasks=1                   # Number of tasks
#SBATCH --time=4:00:00                # Run time
#SBATCH --mem=50g                     # Memory pool for all cores (in MB: 4096 == 4 GB)
#SBATCH -o /scratch/scw2160/09_logs/checkMtreeqa5-%A.out
#SBATCH -e /scratch/scw2160/09_logs/checkMtreeqa5-%A.err

module load CheckM/1.1.3

# you can either specify the path to the checkm database in a variable accessed by checkm:
#export CHECKM2DB="/home/b.tbn23vlc/Checkm2_area/CheckM2_database.dmnd"

# OR provide the full path to the database using the --database_path option when you run checkm predict:

# assign input and output folders to variables that can be changed in different runs:
#in_dir=/scratch/scw2160/02_outputs/flye_asm/fasta_files
out_dir=/scratch/scw2160/02_outputs/flye_asm/CheckM/

# if you don't run the "export CHECKM2DB" command above, you can assign the database to a variable name:
# my_db=/home/b.tbn23vlc/Checkm2_area/CheckM2_database.dmnd

# automatically create the output directory if it doesn't already exist:
 mkdir -p ${out_dir}

# run the checkm2 predict analysis (the ${} bits will automatically put the appropriate data and output folders in, as long as you define those variables correctly in the lines above)
#gtdbtk classify_wf --genome_dir ${in_dir} --out_dir ${out_dir} -x .fasta

checkm tree_qa /scratch/scw2160/02_outputs/flye_asm/CheckM/ -o 5 -f ~/checkmtreeqa/checkmtreeqa_msa.txt
