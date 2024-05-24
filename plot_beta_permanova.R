source("env.R")

generate_model <- function(dependent, selected_predictors,
                           predictor_separator = " + ") {
  if (length(selected_predictors) == 0) {
    return("")
  }

  # Generate all non-empty subsets of the predictors list
  subsets <- unlist(lapply(1:length(selected_predictors), function(n) {
    combn(selected_predictors, n, simplify = FALSE)
  }), recursive = FALSE)

  # Flatten the list
  subsets <- lapply(subsets, function(x) unlist(x))

  # Create interaction terms
  interaction_terms <- lapply(subsets, function(set) {
    paste(set, collapse = ":")
  })

  model_formula <- paste(dependent, "~",
                    paste(interaction_terms, collapse = predictor_separator))

  return(model_formula)
}

permanova <- function(transect, species, method, model) {
  if (nchar(model) == 0) {
    empty_df <- data.frame(c("Select at least one predictor."))
    colnames(empty_df) <- c(" ")
    return (empty_df)
  }

  mycopins <- get_community_data(transect, species)
  mycopins.env <- get_environment_data(transect, species)

  if (any(rowSums(mycopins, na.rm = TRUE) == 0)) {
    empty_df <- data.frame(c("No variance to analyze."))
    colnames(empty_df) <- c(" ")
    return (empty_df)
  }

  mycopins.dist <- vegdist(mycopins, method = method)
  mycopins.mds <- metaMDS(mycopins, try=1000, distance = method, k = 2)
  mycopins.ado <- adonis2(as.formula(model), data = mycopins.env)
  mycopins.ado <- round(mycopins.ado, 6)
  return(mycopins.ado)
}
