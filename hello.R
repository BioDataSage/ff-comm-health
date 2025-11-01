##====================================
# Drivers of Vulnerability Analysis
#=====================================

## so we want to look at vulnerability driver status
library(tidyverse)


# symptoms <- Rdata |> 
#   select(STATE,RPL_THEMES, RPL_THEME1, RPL_THEME2, RPL_THEME3, RPL_THEME4) |> 
#   rename("SVI"=RPL_THEMES,
#          "Socioecomic"=RPL_THEME1,
#          "household"=RPL_THEME2,
#          "racial"=RPL_THEME3,
#          "housing"=RPL_THEME4) |> 
#   pivot_longer(-c(STATE),
#                names_to = "variables",
#                values_to = "index") |> 
#   group_by(STATE,variables) |> 
#   drop_na(index) |> 
#   summarise(index=mean(index), .groups = "drop") |> 
#   pivot_wider(id_cols = STATE,
#               names_from = variables,
#               values_from = index)



data <- read.csv("/Users/mac/Downloads/community_health_evaluation_dataset.csv")

Rdata <- saveRDS(data, "Rdata.rds")







# 
#   group_by(STATE) |> 
#   summarise(SVI = mean(RPL_THEMES))
