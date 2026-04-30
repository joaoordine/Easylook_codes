
# Instalar paquete SangeranalyseR -----------------------------------------


BiocManager::install("sangeranalyseR")


# Set up ambiente ---------------------------------------------------------

dir.create("Nadia")
setwd("/mnt/data/dcosta/Nadia/")



file.copy("~/Descargas/Resultados_Macrogen_HC00532078-20230628T184820Z-001.zip", to = "/mnt/data/dcosta/Nadia/")

unzip("Resultados_Macrogen_HC00532078-20230628T184820Z-001.zip")



# Librerías -----------------------------------------------------------------

library(sangeranalyseR)
library(tidyverse)
library(magrittr)

# Seleccionar archivos ab1 ------------------------------------------------

archivos <- list.files(path = "Resultados_Macrogen_HC00532082/00_ab1", pattern = ".ab1$", full.names = T)


# Analisis de calidad y trimming ------------------------------------------

reads <- list()

for(i in 1:length(archivos)){
  sgf <- SangerRead(readFileName = archivos[i],
                    readFeature = "Forward Read",
                    M1TrimmingCutoff = NULL,
                    M2CutoffQualityScore = 20,
                    M2SlidingWindowSize = 5, 
                    TrimmingMethod = "M2")
  try(writeFasta(sgf, outputDir = "01_fastas/"))
  generateReport(sgf, outputDir = "00_reportes")
  reads[[i]] <- sgf
}
warnings()
