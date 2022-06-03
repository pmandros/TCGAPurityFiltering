###install devtools package with install.packages("devtools")
###then install the package with devtools::install() (provided you are at the project folder)


library(TCGAPurityFiltering)

## read a TCGA assay
# gene_exp_file <- "...LUAD_gene_expression.txt"
# gene_expression <- read.csv(file = gene_exp_file, sep="\t", header=TRUE, row.names = 1)

#create object from TCGAPurityFiltering class
obj <- CreateTCGAPurityFilteringObject()

#get the purities for whole TCGA
TCGA_purities <-obj$TCGA_purities

#get the purities of samples with LUAD (all estimation methods)
LUAD_purities <-obj$get_tissue_purities(cancer_type = "LUAD")

#get the purities of samples with LUAD estimated with CPE
#possible methods are ESTIMATE, ABSOLUTE, LUMP, IHC, CPE")
LUAD_purities_CPE <-obj$get_tissue_purities(cancer_type = "LUAD", filter_method = "CPE")

#filter the gene expression of LUAD based on ESTIMATE purities and with threshold 0.7
filtered_LUAD_assay_ESTIMATE <-obj$filter_assay(assay = gene_expression, cancer_type = "LUAD", filter_method =  "ESTIMATE", threshold = 0.7)

