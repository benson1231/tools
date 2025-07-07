# library -----------------------------------------------------------------
library(here)
library(dplyr)
library(tibble)
library(stringr)
library(ggplot2)
library(org.Hs.eg.db)
library(TCGAbiolinks)


# load utils --------------------------------------------------------------
utils_path <- here("git", "tools", "TCGA", "utils.R")
source(utils_path)
# source("https://raw.githubusercontent.com/benson1231/tools/main/TCGA/utils.R")


# define variable ---------------------------------------------------------
output_path <- here("test")
TCGA_project_name <- "TCGA-OV"
data_type <- "Gene_Expression"


# download raw data -------------------------------------------------------
download_TCGA("TCGA-OV", "Gene_Expression", output_path)


# download clinical data --------------------------------------------------
clinical_data <- GDCquery_clinic(TCGA_project_name, "clinical")
clinical_file_path <- paste0(gsub("TCGA-", "TCGA_", TCGA_project_name), "_", data_type, ".RDS")
saveRDS(clinical_data, clinical_file_path)


# load data ---------------------------------------------------------------
# expression data
exp_file_path <- file.path(output_path, paste0(gsub("TCGA-", "TCGA_", TCGA_project_name), "_", data_type, ".RDS"))
exp_data <- exp_file_path %>% 
  readRDS()

# clinical data
clinical_data <- clinical_file_path %>% 
  readRDS()


# RNAseq ------------------------------------------------------------------
gene_expression <- SummarizedExperiment::assay(exp_data) %>% as.data.frame()

# Mapping Ensembl ID to gene symbol
gene_anno <- AnnotationDbi::select(
  org.Hs.eg.db,
  keys = gsub("\\..*", "", rownames(gene_expression)),  # Remove version number
  columns = c("SYMBOL", "GENENAME"),
  keytype = "ENSEMBL"
) %>% 
  as.data.frame() %>% 
  filter(!is.na(SYMBOL)) %>%
  group_by(ENSEMBL) %>%
  slice_head(n = 1)%>%
  ungroup()

gene_df <- gene_expression %>% 
  rownames_to_column("ENSEMBL") %>% 
  mutate(ENSEMBL = gsub("\\..*", "", ENSEMBL)) %>% 
  left_join(., gene_anno[,c("ENSEMBL", "SYMBOL")], by = "ENSEMBL") %>% 
  filter(!is.na(SYMBOL)) %>%
  dplyr::select(-ENSEMBL) %>%
  group_by(SYMBOL) %>%
  summarise(across(where(is.numeric), sum)) %>%    # Aggregate (sum) each SYMBOL
  column_to_rownames("SYMBOL")

# sample_info
meta_data <- get_TCGA_sample_info(colnames(gene_df)) 
sample_info <- meta_data%>%
  left_join(., clinical_data, by = "submitter_id") %>% 
  mutate(stage = case_when(
    grepl("^Stage I[A-C]?$", figo_stage)     ~ "Stage I",
    grepl("^Stage II[A-C]?$", figo_stage)    ~ "Stage II",
    grepl("^Stage III[A-C]?$", figo_stage)   ~ "Stage III",
    grepl("^Stage IV", figo_stage)           ~ "Stage IV",
    TRUE                                     ~ "Unknown"
  )) %>% 
  mutate(stage = factor(stage, levels = c("Stage I", "Stage II", "Stage III", "Stage IV", "Unknown"))) %>%
  arrange(stage)


# These are named vectors where names correspond to sample IDs, and values correspond to the annotation category (e.g., stage or group).
stage_labels <- setNames(sample_info$stage, sample_info$sample_id)
risk_labels <- setNames(sample_info$risk_group, sample_info$sample_id)

# Define annotation colors
ann_colors <- list(
  Stage = c(
    "Stage I" = "#A6CEE3",
    "Stage II" = "#1F78B4",
    "Stage III" = "#B2DF8A",
    "Stage IV" = "#33A02C",
    "Unknown" = "lightgrey"
  ),
  Risk = c(
    "高" = "salmon",
    "低" = "grey40"
  )
)

# Create top annotation
top_annotation <- HeatmapAnnotation(
  Risk = risk_labels,
  Stage = stage_labels,
  col = ann_colors,
  annotation_name_side = "left"
)

# plot heatmap
target_genes <- c("ADAM9", "ANXA8L1", "FSTL3", "HTRA1", "PDPN", "RABAC1", "TGFBI", "TPM4", "TWIST1", "ZEB1")
plot_TCGA_heatmap(gene_df, top_annotation = top_annotation, target_genes, cluster_columns = F)

# plot TN plot
plot_TN_plot(exp_df = gene_df, target = "TP53")






