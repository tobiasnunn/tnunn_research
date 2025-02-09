find ~/ -maxdepth 1 -type d -name "GC*_annotation" -exec bash -c 'zip -r "${1%/}.zip" "$1"' _ {} \;

mv *.zip ~/processed_accessions/

rm -R GC*_annotation
