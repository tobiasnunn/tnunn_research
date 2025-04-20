#!/bin/bash
while IFS=$'\t' read -r accession filename; do
    ACCESSION=$accession
    FILENAME=$filename
    sbatch eggnogslurmrunner.sh "$ACCESSION" "$FILENAME"
done < ./control_files/genera_control_file_batch_aa.tsv
