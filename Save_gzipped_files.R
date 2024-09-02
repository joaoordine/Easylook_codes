# Open a connection to a gzipped file
gz_con <- gzfile("/home/strawberry/Documents/Saureus_genomes/gene_presence_absence.csv.gz", "wt")

# Write the data to the gzipped file
write.table(gene_presence_absence, file = gz_con, sep = ",", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Close the connection
close(gz_con)
