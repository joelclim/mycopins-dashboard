source("env.R")

nmds <- function(transect, species, variable, method) {
  mycopins <- get_community_data(transect, species)
  mycopins.env <- get_environment_data(transect, species)

  if (any(rowSums(mycopins, na.rm = TRUE) == 0)) {
    return (list(method = method,
                 mycopins.ano = "No similarities to analyze."))
  }

  mycopins.dist <- vegdist(mycopins, method = method)
  mycopins.mds <- metaMDS(mycopins, try = 1000, distance = method, k = 2)
  mycopins.ano <- with(mycopins.env, anosim(mycopins.dist, mycopins.env[[variable]]))

  ano <- paste0("ANOSIM statistic R: ", mycopins.ano["statistic"],
                "\n      Significance: ", mycopins.ano["signif"])

  return(list(mycopins = mycopins,
              mycopins.env = mycopins.env,
              mycopins.dist = mycopins.dist,
              mycopins.mds = mycopins.mds,
              mycopins.ano = ano))
}

plot_nmds <- function(nmds_analysis, variable, draw,
                      graph_type, show_sites, show_species, show_vectors) {
  if (length(nmds_analysis) == 2) {
    plot(1, type = "n",
         xlab = "", ylab = "",
         xlim = c(0, 1), ylim = c(0, 1),
         xaxt = 'n', yaxt = 'n', bty = 'n')

    text(0.5, 0.5, "You have empty rows: their dissimilarities",
         cex = 1.5, col = "red", font = 2, adj = c(0.5, 0))
    text(0.5, 0.45,
         paste0("may be meaningless in method: ", nmds_analysis$method),
         cex = 1.5, col = "red", font = 2, adj = c(0.5, 1))
  } else {
    mycopins <- nmds_analysis$mycopins
    mycopins.env <- nmds_analysis$mycopins.env
    mycopins.dist <- nmds_analysis$mycopins.dist
    mycopins.mds <- nmds_analysis$mycopins.mds

    plot <- ordiplot(mycopins.mds, type=graph_type)

    colors <- viridis(length(unique(mycopins.env[[variable]])))
    if ("ellipse" == draw) {
      ordiellipse(mycopins.mds, groups=mycopins.env[[variable]],
                  draw="polygon", col=colors, label=TRUE)

    } else if ("hull" == draw) {
      ordihull(mycopins.mds, groups=mycopins.env[[variable]],
               draw="polygon", col=colors, label=TRUE)
    }

    if (show_sites) {
      orditorp(mycopins.mds, display="sites", cex=0.78, air=0.01)
    }
    if (show_species) {
      orditorp(mycopins.mds, display="species", cex=0.50, col="red", air=0.01)
    }

    for(variable in show_vectors) {
      env <- data.frame(mycopins.env[[variable]])
      names(env) <- variable
      env_vector <- envfit(mycopins.mds, env, perm=1000, arrows = TRUE)
      plot(env_vector, cex=0.80, add=TRUE)
    }
  }
}

# plot_beta_diversity_distribution <- function(transect, species, method) {
#   mycopins <- get_community_data(transect, species)
#   mycopins.dist <- vegdist(mycopins, method = method)
#
#   return(as.data.frame(round(as.matrix(mycopins.dist), 4)))
# }