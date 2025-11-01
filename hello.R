##====================================
# Drivers of Vulnerability Analysis
#=====================================

## so we want to look at vulnerability driver status
library(tidyverse)


symptoms <- Rdata |> 
  select(STATE,RPL_THEMES, RPL_THEME1, RPL_THEME2, RPL_THEME3, RPL_THEME4) |> 
  rename("SVI"=RPL_THEMES,
         "Socioecomic"=RPL_THEME1,
         "household"=RPL_THEME2,
         "racial"=RPL_THEME3,
         "housing"=RPL_THEME4) |> 
  pivot_longer(-c(STATE),
               names_to = "variables",
               values_to = "index") |> 
  group_by(STATE,variables) |> 
  summarise(index=mean(index), .groups = "drop") |> 
  pivot_wider(id_cols = STATE,
              names_from = variables,
              values_from = index)











# 
#   group_by(STATE) |> 
#   summarise(SVI = mean(RPL_THEMES))
