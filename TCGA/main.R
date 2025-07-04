# library -----------------------------------------------------------------
library(here)
library(dplyr)
library(tibble)
library(stringr)
library(ggplot2)


# load utils --------------------------------------------------------------
utils_path <- here("git", "tools", "TCGA", "utils.R")
source(utils_path)


# define variable ---------------------------------------------------------
output_path <- here("test")
TCGA_project_name <- "COAD"
data_type <- "miRNA_Expression"
target <- "hsa-mir-8077"


# check input -------------------------------------------------------------


# download raw data -------------------------------------------------------
if(data_type == "miRNA_Expression"){
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




# plot miRNA TN plot ------------------------------------------------------
exp_df <- exp_data %>% 
  as.data.frame() %>% 
  dplyr::select(miRNA_ID, starts_with("reads_per_million_miRNA_mapped")) %>% 
  tibble::column_to_rownames("miRNA_ID") %>% 
  rename_with(~ str_remove(., "^reads_per_million_miRNA_mapped_"))


plot_miRNA_TN_plot(exp_df = exp_df, target = target)
















