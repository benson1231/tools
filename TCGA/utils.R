
# plot_TN_plot ------------------------------------------------------------

plot_TN_plot <- function(exp_df, target, log_transform = FALSE, palette = c("normal" = "grey40", "tumor" = "salmon")) {
  library(dplyr)
  library(tibble)
  library(ggplot2)
  
  # Define TCGA sample type codes
  TCGA_sample_type_normal <- c("10", "11")  # 10 = Blood Derived Normal, 11 = Solid Tissue Normal
  TCGA_sample_type_tumor  <- c("01", "03")  # 01 = Primary Solid Tumor, 03 = Blood Derived Tumor
  
  # Check if the target miRNA/gene exists in the data
  if (!target %in% rownames(exp_df)) {
    stop("Target not found in rownames of exp_df: ", target)
  }
  
  # Extract sample IDs and determine their sample type code (14th–15th characters)
  sample_info <- colnames(exp_df) %>%
    as_tibble() %>%
    setNames("sample_id") %>%
    mutate(sample_type_code = substr(sample_id, 14, 15))
  
  # Print distribution of sample type codes
  message("Sample Type Code Distribution:")
  print(table(sample_info$sample_type_code))
  
  # Extract expression values of the target gene/miRNA and merge with sample type
  target_exp <- exp_df[target, ] %>%
    t() %>%
    as.data.frame() %>%
    setNames("expression") %>%
    rownames_to_column("sample_id") %>%
    left_join(sample_info, by = "sample_id") %>%
    filter(sample_type_code %in% c(TCGA_sample_type_normal, TCGA_sample_type_tumor)) %>%
    mutate(
      group = ifelse(sample_type_code %in% TCGA_sample_type_normal, "normal", "tumor"),
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

