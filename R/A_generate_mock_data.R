# Script A: generate mock data for the circular bar plot
#
# This script creates a fully synthetic dataset with the same structure
# expected by Script B. It does not contain or reproduce the original data
# used for the conference poster.

library(dplyr)
library(tidyr)
library(readr)

# Generic labels are used deliberately so that the public example is not tied
# to the original study dataset.
groups <- c("Group A", "Group B", "Group C", "Group D")
categories <- paste("Category", 1:9)

# Fixed seed makes the example reproducible.
set.seed(2026)

mock_data <- expand_grid(
  group = groups,
  category = categories
) %>%
  mutate(
    # Synthetic integer values used only for demonstration.
    value = sample(0:8, size = n(), replace = TRUE),
    group = factor(group, levels = groups)
  ) %>%
  arrange(group, category) %>%
  mutate(group = as.character(group))

dir.create("data", showWarnings = FALSE)

write_csv(mock_data, file.path("data", "mock_data.csv"))

message("Mock data written to data/mock_data.csv")
