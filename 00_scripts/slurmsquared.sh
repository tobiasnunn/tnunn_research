#!/bin/bash
while IFS=$'\t' read -r accession filename; do
    ACCESSION=$accession
    FILENAME=$filename
    sbatch eggnogslurmrunner.sh "$ACCESSION" "$FILENAME"
done < prototypedatafile1.tsv
