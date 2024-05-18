# Find items lacking in a list compared against another one

## Sort the files
sort blast_out_genomes.tsv -o blast_out_genomes_sorted.tsv
sort prokka_genomes.tsv -o prokka_genomes_sorted.tsv

## Find genome codes that are in prokka_genomes.tsv but not in blast_out_genomes.tsv
comm -23 prokka_genomes_sorted.tsv blast_out_genomes_sorted.tsv > missing_genomes.txt

## Moving lacking items from list to desired directory 
source_dir="/temporario2/11217468/projects/saureus_global/prokka_output/all_faa_files"
destination_dir="/temporario2/11217468/projects/saureus_global/transporters_blast/all_faa_files/remaining_genomes"

mkdir -p "$destination_dir"

while IFS= read -r genome_code; do
  # Construct the filename from the genome code
  faa_file="${genome_code}_genomic.faa"
  
  # Check if the file exists in the source directory
  if [[ -f "${source_dir}/${faa_file}" ]]; then
    # Copy the file to the destination directory
    cp "${source_dir}/${faa_file}" "$destination_dir"
    echo "Copied ${faa_file} to ${destination_dir}"
  else
    echo "File ${faa_file} not found in ${source_dir}"
  fi
done < missing_genomes.txt



