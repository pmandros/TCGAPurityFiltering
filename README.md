# TCGAPurityFiltering

An R library that handles tumor purity scores for The Cancer Genome Atlas Program (TCGA) project. The library can retrieve tumor purity scores for all cancer types in TCGA and 5 tumor purity estimation techniques. The library also filters TCGA assays for given tumor purity thresholds.

The library uses the purity data provided by Aran et al., "Systematic pan-cancer analysis of tumour purity" (https://www.nature.com/articles/ncomms9971#MOESM1235).


# Installing

To install and use the library:
- first install.packages("devtools")
- then install the library with devtools::install() (provided you are at the project folder)
- load the library in your code with library(TCGAPurityFiltering)

An example is provided that explores the functionality of the library.
