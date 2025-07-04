# library -----------------------------------------------------------------
library(here)
library(dplyr)
library(tibble)
library(stringr)
library(ggplot2)
library(org.Hs.eg.db)
library(ComplexHeatmap)


# load utils --------------------------------------------------------------
utils_path <- here("git", "tools", "TCGA", "utils.R")
source(utils_path)


# define variable ---------------------------------------------------------
output_path <- here("test")
TCGA_project_name <- "COAD"
data_type <- "miRNA_Expression"
target <- "hsa-mir-8077"

data_type <- "Gene_Expression"
# check input -------------------------------------------------------------


# download raw data -------------------------------------------------------
message("For more details on query parameters, please refer to: https://www.bioconductor.org/packages/devel/bioc/vignettes/TCGAbiolinks/inst/doc/query.html#Harmonized_data_options")

if(data_type == "Gene_Expression"){
  query_exp <- GDCquery(
    project = paste0("TCGA-", TCGA_project_name),
    data.category = "Transcriptome Profiling",
    data.type = "Gene Expression Quantification",
    workflow.type = "STAR - Counts"
  )
}else if(data_type == "miRNA_Expression"){
  query_exp <- GDCquery(
    project = paste0("TCGA-", TCGA_project_name),
    data.category = "Transcriptome Profiling",
    data.type = "miRNA Expression Quantification"
  )
}

GDCdownload(query_exp)
exp_data <- GDCprepare(query_exp)
exp_file_path <- paste0(output_path, "/TCGA_", TCGA_project_name, "_", data_type, ".RDS")
saveRDS(exp_data, exp_file_path)


# download clinical data --------------------------------------------------
clinical_data <- GDCquery_clinic(paste0("TCGA-", TCGA_project_name), "clinical")
clinical_file_path <- paste0(output_path, "/TCGA_", TCGA_project_name, "_clinical.RDS")
saveRDS(clinical_data, clinical_file_path)


# load data ---------------------------------------------------------------
# expression data
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



ComplexHeatmap::Heatmap(gene_df[1:50, 1:50])


plot_TN_plot(exp_df = gene_df, target = "TP53")


# plot miRNA TN plot ------------------------------------------------------
exp_df <- exp_data %>% 
  as.data.frame() %>% 
  dplyr::select(miRNA_ID, starts_with("reads_per_million_miRNA_mapped")) %>% 
  tibble::column_to_rownames("miRNA_ID") %>% 
  rename_with(~ str_remove(., "^reads_per_million_miRNA_mapped_"))


plot_TN_plot(exp_df = exp_df, target = target)
















