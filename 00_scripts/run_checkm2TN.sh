#!/bin/bash
#SBATCH --account=scw2160
#SBATCH --job-name=check2
#SBATCH --partition=compute           # compute (max resources: 192g; ), highmem (max resources: 384g; 40 threads; 72h)
#SBATCH --ntasks=10                   # Number of tasks
#SBATCH --time=4:00:00                # Run time
#SBATCH --mem=124g                     # Memory pool for all cores (in MB: 4096 == 4 GB)
#SBATCH -o /scratch/scw2160/09_logs/checkm-%A.out
#SBATCH -e /scratch/scw2160/09_logs/checkm-%A.err

module load CheckM2/0.1.3

# you can either specify the path to the checkm database in a variable accessed by checkm:
export CHECKM2DB="/home/b.tbn23vlc/Checkm2_area/CheckM2_database.dmnd"

# OR provide the full path to the database using the --database_path option when you run checkm predict:

# assign input and output folders to variables that can be changed in different runs:
in_dir=~/fasta_files
out_dir=/scratch/scw2160/02_outputs/flye_asm/CheckM2_20241228

# if you don't run the "export CHECKM2DB" command above, you can assign the database to a variable name:
# my_db=/home/b.tbn23vlc/Checkm2_area/CheckM2_database.dmnd

# automatically create the output directory if it doesn't already exist:
 mkdir -p ${out_dir}

# run the checkm2 predict analysis (the ${} bits will automatically put the appropriate data and output folders in, as long as you define those variables correctly in the lines above):
checkm2 predict -x .fasta -i ${in_dir} -o ${out_dir} 


