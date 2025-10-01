# -------------------------------
# Paths
# -------------------------------
GENOME_DIR="$HOME/Documents/Masters/cacnes_genomic_anal/Cacnes_genomes/genomes_pubmlst"
OUTPUT_DIR="$HOME/Documents/Masters/cacnes_genomic_anal/Cacnes_genomes/amrfinderplus_output"

# Make sure the output directory exists
mkdir -p "$OUTPUT_DIR"

# -------------------------------
# Run AMRFinderPlus on each genome
# -------------------------------
for genome_file in "$GENOME_DIR"/*.fas; do
    genome_name=$(basename "$genome_file" .fas)
    
    echo "Analyzing $genome_name ..."
    
    amrfinder \
        --nucleotide "$genome_file" \
        --plus \
        --threads 8 \
        --output "$OUTPUT_DIR/${genome_name}_AMR.txt"
done

# -------------------------------
# Optional: create a summary
# -------------------------------
# If you want a combined summary table, you can use 'amrfinder' built-in merge
cd "$OUTPUT_DIR"
amrfinder --merge *_AMR.txt > AMRFinderPlus_summary.txt
echo "AMRFinderPlus analysis completed. Summary saved to AMRFinderPlus_summary.txt"
