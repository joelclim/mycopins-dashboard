plot_alpha_species_frequency <- function(transect, species) {
  mycopins <- get_community_data(transect, species)

  species_list <- data.frame(colSums(mycopins))

  names(species_list) <- c('Frequency')
  species_list$Species <- rownames(species_list)
  species_list <- species_list[,c('Species', 'Frequency')]
  species_list <- species_list[order(-species_list$Frequency), ]
  rownames(species_list) <- 1:nrow(species_list)

  return(species_list)
}