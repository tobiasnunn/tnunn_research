#!/bin/bash
#SBATCH --account=scw2160
#SBATCH --job-name=gtdbtk
#SBATCH --partition=compute           # compute (max resources: 192g; ), highmem (max resources: 384g; 40 threads; 72h)
#SBATCH --ntasks=5                   # Number of tasks
#SBATCH --time=24:00:00                # Run time
#SBATCH --mem=50g                     # Memory pool for all cores (in MB: 4096 == 4 GB)
#SBATCH -o /scratch/scw2160/09_logs/gtdbtk-%A.out
#SBATCH -e /scratch/scw2160/09_logs/gtdbtk-%A.err
#SBATCH --mail-user=0rtpjri2@anonaddy.me
#SBATCH --mail-type=ALL

module load gtdb-tk/2.1.1

# you can either specify the path to the checkm database in a variable accessed by checkm:
#export CHECKM2DB="/home/b.tbn23vlc/Checkm2_area/CheckM2_database.dmnd"

# OR provide the full path to the database using the --database_path option when you run checkm predict:

# assign input and output folders to variables that can be changed in different runs:
in_dir=/home/b.tbn23vlc/wolbachia
out_dir=/home/b.tbn23vlc/wolbachia_out

# if you don't run the "export CHECKM2DB" command above, you can assign the database to a variable name:
# my_db=/home/b.tbn23vlc/Checkm2_area/CheckM2_database.dmnd

# automatically create the output directory if it doesn't already exist:
 mkdir -p ${out_dir}

# run the checkm2 predict analysis (the ${} bits will automatically put the appropriate data and output folders in, as long as you define those variables correctly in the lines above)
#gtdbtk classify_wf --genome_dir ${in_dir} --out_dir ${out_dir} -x .fasta

gtdbtk de_novo_wf --genome_dir ${in_dir} --bacteria --outgroup_taxon p__Chloroflexota --out_dir ${out_dir} -x .fa --cpus 10


