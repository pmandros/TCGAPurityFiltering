TCGAPurityFiltering=setRefClass("TCGAPurityFiltering",
         fields = list(TCGA_purities= "data.frame"),
         methods = list(
           filter_assay = function(assay, cancer_type, filter_method, threshold){
             if(class(assay) != "data.frame"){
               stop("Error: Assay needs to be a data.frame")
             }

             if(!(filter_method %in% colnames(.self$TCGA_purities))){
               stop("Error: Purity estimation method not found (misspelled maybe?). Options are ESTIMATE,
                    ABSOLUTE, LUMP, IHC, CPE")
             }

             if(!(cancer_type %in% .self$TCGA_purities$Cancer_type)){
               stop("Error: TCGA cancer type not found (misspelled maybe?)")
             }

             cancer_type_TCGA_purities <- .self$get_tissue_purities(cancer_type)

             #for some reason the tcga barcodes are parsed with . instead of -
             colnames(assay) <- gsub(pattern = "\\.", replacement = "-",colnames(assay))

             not_in_assay <- rownames(cancer_type_TCGA_purities) %in% colnames(assay)
             if(!all(not_in_assay)){
               warning("Warning:  Sample names from purities file not found in TCGA tissue names.")
             }

             #remove samples not found in TCGA expression data
             cancer_type_TCGA_purities<-cancer_type_TCGA_purities[which(not_in_assay==TRUE),]

             #sort cancer_type_TCGA_purities according to TCGA assay order
             p <- match_order(rownames(cancer_type_TCGA_purities), colnames(assay))
             cancer_type_TCGA_purities <- cancer_type_TCGA_purities[p,]

             #filter TCGA sample names according to threshold and filter_method
             p <- which(cancer_type_TCGA_purities[[filter_method]]>=threshold)
             dataframe_to_return <- assay[,p]
             return(dataframe_to_return)
           },
           get_tissue_purities = function(cancer_type, filter_method=NULL){
             if(!(cancer_type %in% .self$TCGA_purities$Cancer_type)){
               stop("Error: TCGA cancer type not found (misspelled maybe?)")
             }
             cancer_type_TCGA_purities <- .self$TCGA_purities %>% subset(Cancer_type == cancer_type)
             if(!is.null(filter_method)){
               if(!(filter_method %in% colnames(.self$TCGA_purities))){
                 stop("Error: Purity estimation method not found (misspelled maybe?). Options are ESTIMATE,
                    ABSOLUTE, LUMP, IHC, CPE")
               }
               return(cancer_type_TCGA_purities %>% dplyr::select(filter_method))
             }
             else{
               return(cancer_type_TCGA_purities)
             }

           }
         )
)

#' @export "CreateTCGAPurityFilteringObject"
CreateTCGAPurityFilteringObject <- function(TCGA_purities_file="inst/extdata/purities.csv"){
  fpath <- system.file("extdata", "purities.csv", package="TCGAPurityFiltering")
  TCGA_purities <- read.csv(file = fpath, sep="\t", header=TRUE, row.names = 1)
  TCGA_purities$X <-NULL
  TCGA_purities$ESTIMATE <- as.numeric(gsub(",", ".", TCGA_purities$ESTIMATE))
  TCGA_purities$ABSOLUTE <- as.numeric(gsub(",", ".", TCGA_purities$ABSOLUTE))
  TCGA_purities$LUMP <- as.numeric(gsub(",", ".", TCGA_purities$LUMP))
  TCGA_purities$IHC <- as.numeric(gsub(",", ".", TCGA_purities$IHC))
  TCGA_purities$CPE <- as.numeric(gsub(",", ".", TCGA_purities$CPE))
  s <- TCGAPurityFiltering$new(TCGA_purities = TCGA_purities)
}





