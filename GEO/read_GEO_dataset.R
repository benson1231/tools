# -----------------------------------------------------------
# Function: read_GEO_dataset
# Author: Benson Lee
# Description:
#   Download a GEO dataset by GSE ID, extract expression matrix,
#   phenotype metadata, and automatically parse "characteristics"
#   fields into clean variables.
# -----------------------------------------------------------

read_GEO_dataset <- function(GSE_id) {
  
  # Load required package
  library(GEOquery)
  
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
