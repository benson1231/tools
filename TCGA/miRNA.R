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
TCGA_project_name <- "TCGA-COAD"
data_type <- "miRNA_Expression"


# download raw data -------------------------------------------------------
download_TCGA(TCGA_project_name, data_type, output_path)


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


# plot miRNA TN plot ------------------------------------------------------
exp_df <- exp_data %>% 
  as.data.frame() %>% 
  dplyr::select(miRNA_ID, starts_with("reads_per_million_miRNA_mapped")) %>% 
  tibble::column_to_rownames("miRNA_ID") %>% 
  rename_with(~ str_remove(., "^reads_per_million_miRNA_mapped_"))

# sample_info
sample_info <- get_TCGA_sample_info(colnames(exp_df))

# plot TN plot
target <- "hsa-mir-501"
plot_TN_plot(exp_df = exp_df, target = target)







