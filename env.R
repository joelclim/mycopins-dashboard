if (!require("DT")) install.packages("DT")
if (!require("dplyr")) install.packages("dplyr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("labdsv")) install.packages("labdsv", dependencies = TRUE)
if (!require("readr")) install.packages("readr")
if (!require("vegan")) install.packages("vegan", repos = c(
  vegandevs = 'https://vegandevs.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))
if (!require(viridis)) install.packages("viridis")

library(DT)
library(dplyr)
library(labdsv)
library(ggplot2)
library(readr)
library(vegan)
library(viridis)


get_community_data <- function(transect, species) {
  if (1 == species) {
    community_file <- paste0("./data/", transect, "/mycopins_community.csv")
  } else if (2 == species) { # genus/species
    community_file <- paste0("./data/", transect, "/mycopins_community_fungi.csv")
  } else if (3 == species) { # wood saprotrophs fungi
    community_file <- paste0("./data/", transect, "/mycopins_community_wood_saprotroph.csv")
  }

  community_df <- read_csv(community_file, show_col_types = FALSE)

  return(community_df)
}


get_environment_data <- function(transect, species) {
  if (1 == species) {
    environment_file <- paste0("./data/", transect, "/mycopins_environment.csv")
  } else if (2 == species) { # genus/species
    environment_file <- paste0("./data/", transect, "/mycopins_environment_fungi.csv")
  } else if (3 == species) { # wood saprotrophs fungi
    environment_file <- paste0("./data/", transect, "/mycopins_environment_wood_saprotroph.csv")
  }
  
  environment_df <- read_csv(environment_file, show_col_types = FALSE)
  
  return(environment_df)
}


get_environment_variables <- function(transect, species,
                                      exclude_list = c("Tag", "Date.Collected")) {
  mycopins.env <- get_environment_data(transect, species)
  
  env_vars <- names(mycopins.env)
  env_vars <- env_vars[!env_vars %in% exclude_list]
  
  return (env_vars)
}


get_gbif_taxon_data <- function(transect, species) {
  if (1 == species) {
    gbif_taxon_file <- paste0("./data/", transect, "/mycopins_gbif_taxon.csv")
  } else if (2 == species) { # genus/species
    gbif_taxon_file <- paste0("./data/", transect, "/mycopins_gbif_taxon_fungi.csv")
  } else if (3 == species) { # wood saprotrophs fungi
    gbif_taxon_file <- paste0("./data/", transect, "/mycopins_gbif_taxon_wood_saprotroph.csv")
  }
  
  gbif_taxon_df <- read_csv(gbif_taxon_file, show_col_types = FALSE)
  
  return(gbif_taxon_df)
}


get_fungal_traits_data <- function(transect, species) {
  if (1 == species) {
    fungal_traits_file <- paste0("./data/", transect, "/mycopins_genus_traits.csv")
  } else if (2 == species) { # genus/species
    fungal_traits_file <- paste0("./data/", transect, "/mycopins_genus_traits_fungi.csv")
  } else if (3 == species) { # wood saprotrophs fungi
    fungal_traits_file <- paste0("./data/", transect, "/mycopins_genus_traits_wood_saprotroph.csv")
  }
  
  fungal_traits_df <- read_csv(fungal_traits_file, show_col_types = FALSE)
  
  return(fungal_traits_df)
}