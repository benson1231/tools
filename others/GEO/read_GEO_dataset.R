# -----------------------------------------------------------
# Function: read_GEO_dataset
# Author: Benson Lee
# Description:
#   Download a GEO dataset by GSE ID, extract the expression
#   matrix and phenotype metadata, and automatically parse the
#   "characteristics" fields into clean variables.
#
# Usage:
#   # Load this function directly from GitHub:
#   source("https://raw.githubusercontent.com/benson1231/tools/main/GEO/read_GEO_dataset.R")
#
#   # Read any GEO dataset (example: GSE53963)
#   data <- read_GEO_dataset("GSE53963")
#
#   # Extract expression matrix and metadata
#   expr  <- data$expression
#   pheno <- data$phenotype
#
#   # Quick checks
#   dim(expr)
#   head(pheno)
#
# Note:
#   This function automatically:
#     - Downloads the GEO Series Matrix
#     - Loads the expression matrix (exprs)
#     - Loads phenotype metadata (pData)
#     - Detects all 'characteristics_ch1' fields
#     - Parses them into separate clean variables
# -----------------------------------------------------------


read_GEO_dataset <- function(GSE_id) {
  
    if (!requireNamespace("GEOquery", quietly = TRUE)) {
    stop("Package 'GEOquery' is required but not installed.")
    }
  
  message("--------------------------------------------------")
  message("Downloading GEO dataset: ", GSE_id)
  message("--------------------------------------------------")
  
  # Get GEO Series
  gse <- getGEO(GSE_id, GSEMatrix = TRUE)
  
  # Handle multi-platform datasets
  if (length(gse) > 1) {
    message("Multiple platforms detected. Using the first one.")
  }
  gse <- gse[[1]]
  
  # -----------------------------------------------------------
  # Expression matrix
  # -----------------------------------------------------------
  expr <- exprs(gse)
  message("\nExpression matrix loaded:")
  message("  Rows (genes/probes): ", nrow(expr))
  message("  Columns (samples):   ", ncol(expr))
  
  # -----------------------------------------------------------
  # Phenotype metadata
  # -----------------------------------------------------------
  pheno <- pData(gse)
  message("\nPhenotype metadata loaded:")
  message("  Samples:             ", nrow(pheno))
  message("  Variables:           ", ncol(pheno))
  
  # -----------------------------------------------------------
  # Parse characteristics
  # -----------------------------------------------------------
  char_cols <- grep("characteristics", colnames(pheno), value = TRUE)
  message("\nDetected characteristics columns: ", length(char_cols))
  
  if (length(char_cols) > 0) {
    message("Parsing characteristics ...")
    
    char_data <- pheno[, char_cols, drop = FALSE]
    
    parsed_list <- lapply(char_data, function(col) {
      parts <- strsplit(as.character(col), ": ")
      vals <- sapply(parts, function(x) if (length(x) > 1) x[2] else NA)
      names_col <- sapply(parts, function(x) if (length(x) > 1) x[1] else NA)
      data.frame(variable = names_col, value = vals, stringsAsFactors = FALSE)
    })
    
    parsed_df <- do.call(cbind, lapply(parsed_list, function(df) df$value))
    colnames(parsed_df) <- sapply(parsed_list, function(df) df$variable[1])
    
    rownames(parsed_df) <- rownames(pheno)
    pheno <- cbind(pheno, parsed_df)
    
    message("  Parsed characteristics added: ", ncol(parsed_df), " variables")
  }
  
  message("--------------------------------------------------")
  message("GEO dataset ", GSE_id, " loaded successfully!")
  message("--------------------------------------------------\n")
  
  # Return list
  return(list(
    expression = expr,
    phenotype = pheno
  ))
}

# End of file
# -----------------------------------------------------------
