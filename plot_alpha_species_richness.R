source("env.R")

library(dplyr)
library(ggplot2)

get_species_richness <- function(dataset, species, variable) {
  mycopins <- get_community_data(dataset, species)
  mycopins.env <- get_environment_data(dataset, species)
  mycopins.env$IndependentVariable <- mycopins.env[[variable]]
  mycopins.env$SpeciesRichness <- specnumber(mycopins)

  return(mycopins.env)
}

plot_species_richness <- function(species_richness, variable) {
  mycopins.env <- species_richness
  ggplot(mycopins.env,
    aes(x = as.factor(IndependentVariable), y = SpeciesRichness)) +
    geom_boxplot() +
    labs(x = variable, y = "SpeciesRichness") +
    theme_classic()
}

summarize_species_richness <- function(species_richness, variable) {
  mycopins.env <- species_richness
  mycopins.env <- mycopins.env[, c(variable, "SpeciesRichness")]

  summary_data <- mycopins.env %>%
    group_by_at(variable) %>%
    summarize(
      Count = n(),
      Mean = round(mean(SpeciesRichness), 2),
      Median = median(SpeciesRichness),
      Min = min(SpeciesRichness),
      Max = max(SpeciesRichness),
      SD = round(sd(SpeciesRichness), 2)
    )

  return(summary_data)
}
