# Load required library
library(tidyverse)
library(edgeR)
library(ComplexHeatmap)
library(circlize)
library(magrittr)



# download_TCGA -----------------------------------------------------------

download_TCGA <- function(TCGA_project_name, 
                          data_type, 
                          output_path = ".") {
  
  valid_types <- c("Gene_Expression", "miRNA_Expression")
  
  if (!data_type %in% valid_types) {
    stop("Invalid 'data_type'. Please choose one of: ", paste(valid_types, collapse = ", "))
  }
  
  if (!grepl("^TCGA-", TCGA_project_name)) {
    stop("Invalid 'TCGA_project_name'. It must start with 'TCGA-', e.g., 'TCGA-OV'")
  }
  
  message("Initializing query for TCGA project: ", TCGA_project_name)
  message("Data type selected: ", data_type)
  message("For details on query parameters, refer to:")
  message("https://www.bioconductor.org/packages/devel/bioc/vignettes/TCGAbiolinks/inst/doc/query.html#Harmonized_data_options")
  
  # Construct query
  if (data_type == "Gene_Expression") {
    message("Constructing query for gene expression data...")
    query_exp <- GDCquery(
      project = TCGA_project_name,
      data.category = "Transcriptome Profiling",
      data.type = "Gene Expression Quantification",
      workflow.type = "STAR - Counts"
    )
  } else if (data_type == "miRNA_Expression") {
    message("Constructing query for miRNA expression data...")
    query_exp <- GDCquery(
      project = TCGA_project_name,
      data.category = "Transcriptome Profiling",
      data.type = "miRNA Expression Quantification"
    )
  }
  
  # Download and prepare
  GDCdownload(query_exp)
  exp_data <- GDCprepare(query_exp)
  
  # Save result
  file_name <- paste0(gsub("TCGA-", "TCGA_", TCGA_project_name), "_", data_type, ".RDS")
  file_path <- file.path(output_path, file_name)
  
  saveRDS(exp_data, file_path)
  message("Expression data saved to: ", file_path)
  
  return(invisible(file_path))
}




# pre-defined -------------------------------------------------------------

# Define TCGA sample type codes
TCGA_sample_type_normal <- c("10", "11")  # 10 = Blood Derived Normal, 11 = Solid Tissue Normal
TCGA_sample_type_tumor  <- c("01", "03")  # 01 = Primary Solid Tumor, 03 = Blood Derived Tumor


# get_TCGA_sample_info ----------------------------------------------------

get_TCGA_sample_info <- function(sample_id_list){
  
  message("For more details on code tables, please refer to: https://gdc.cancer.gov/resources-tcga-users/tcga-code-tables")
  
  # Check validity of sample_id_list
  if (missing(sample_id_list) || length(sample_id_list) == 0) {
    stop("'sample_id_list' is missing or empty.")
  }
  
  if (!is.character(sample_id_list)) {
    stop("'sample_id_list' must be a character vector of TCGA sample IDs.")
  }
  
  message("Input is valid. Processing ", length(sample_id_list), " sample IDs.")
  
  sample_info <- sample_id_list %>%
    as_tibble() %>%
    setNames("sample_id") %>%
    mutate(
      project       = str_split_fixed(sample_id, "-", 7)[, 1],
      tss           = str_split_fixed(sample_id, "-", 7)[, 2],
      participant   = str_split_fixed(sample_id, "-", 7)[, 3],
      sample        = str_sub(str_split_fixed(sample_id, "-", 7)[, 4], 1, 2),
      vial          = str_sub(str_split_fixed(sample_id, "-", 7)[, 4], 3, 3),
      portion       = str_sub(str_split_fixed(sample_id, "-", 7)[, 5], 1, 2),
      analyte       = str_sub(str_split_fixed(sample_id, "-", 7)[, 5], 3, 3),
      plate         = str_split_fixed(sample_id, "-", 7)[, 6],
      center        = str_split_fixed(sample_id, "-", 7)[, 7],
      submitter_id  = paste(project, tss, participant, sep = "-")
    ) %>%     
    mutate(
      group = ifelse(sample %in% TCGA_sample_type_normal, "normal", "other"),
      group = ifelse(sample %in% TCGA_sample_type_tumor, "tumor", "other"),
      group = factor(group, levels = c("normal", "tumor"))
    )
  
  return(sample_info)
  
}




# plot_TN_plot ------------------------------------------------------------

plot_TN_plot <- function(exp_df, target, log_transform = FALSE, palette = c("normal" = "grey40", "tumor" = "salmon")) {
  
  # Check if the target miRNA/gene exists in the data
  if (!target %in% rownames(exp_df)) {
    stop("Target not found in rownames of exp_df: ", target)
  }
  
  # Extract sample IDs and determine their sample type code (14th–15th characters)
  sample_info <- get_TCGA_sample_info(colnames(exp_df))
  
  # Print distribution of sample type codes
  message("Sample Type Code Distribution:")
  print(table(sample_info$sample))
  
  # Extract expression values of the target gene/miRNA and merge with sample type
  target_exp <- exp_df[target, ] %>%
    t() %>%
    as.data.frame() %>%
    setNames("expression") %>%
    rownames_to_column("sample_id") %>%
    left_join(sample_info, by = "sample_id") %>%
    filter(sample %in% c(TCGA_sample_type_normal, TCGA_sample_type_tumor)) %>%
    mutate(
      group = ifelse(sample %in% TCGA_sample_type_normal, "normal", "tumor"),
      group = factor(group, levels = c("normal", "tumor")),
      expression = if (log_transform) log2(expression + 1) else expression
    )
  
  # Create boxplot with jittered points
  p <- ggplot(target_exp, aes(x = group, y = expression, fill = group)) +
    geom_boxplot(outlier.shape = NA, alpha = 0.8) +
    geom_jitter(width = 0.2, size = 2, alpha = 0.6, color = "black") +
    scale_fill_manual(values = palette) +
    labs(
      title = paste("Expression of", target, "in Tumor vs Normal"),
      x = "",
      y = ifelse(log_transform, "log2(Expression + 1)", "Expression (RPM)")
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5),
      legend.position = "none"
    )
  
  return(p)
}



# plot_TCGA_heatmap -------------------------------------------------------

plot_TCGA_heatmap <- function(gene_df, top_annotation,target_genes, cluster_columns = T, cluster_rows = T) {
  
  # Log CPM transformation
  logCPM <- cpm(as.matrix(gene_df), log = TRUE, prior.count = 1)
  
  # Subset for target genes
  heatmap_mat <- logCPM[rownames(logCPM) %in% target_genes, ] %>% as.matrix()
  
  # Z-score standardization by gene
  mat_scale <- heatmap_mat %>%
    t() %>%             # transpose to scale by row (gene)
    scale(scale = TRUE) %>%
    t() %>%
    as.matrix()
  
  # Plot heatmap
  p <- Heatmap(
    mat_scale,
    name = "Expression",
    top_annotation = top_annotation,
    show_row_names = TRUE,
    show_column_names = FALSE,
    cluster_columns = cluster_columns,
    cluster_rows = cluster_rows
  )
  
  return(p)
}

##########################################################################
# # These are named vectors where names correspond to sample IDs, and values correspond to the annotation category (e.g., stage or group).
# stage_labels <- setNames(sample_info$stage, sample_info$sample_id)
# group_labels <- setNames(sample_info$group, sample_info$sample_id)
# 
# # Define annotation colors
# ann_colors <- list(
#   Stage = c(
#     "Stage I" = "#A6CEE3",
#     "Stage II" = "#1F78B4",
#     "Stage III" = "#B2DF8A",
#     "Stage IV" = "#33A02C",
#     "Unknown" = "lightgrey"
#   ),
#   Group = c(
#     "tumor" = "salmon",
#     "normal" = "grey40"
#   )
# )
# 
# # Create top annotation
# top_annotation <- HeatmapAnnotation(
#   Group = group_labels,
#   Stage = stage_labels,
#   col = ann_colors,
#   annotation_name_side = "left"
# )
##########################################################################

