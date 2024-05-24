source("env.R")

library(ggplot2)

plot_alpha_diversity <- function(transect, species, variable, index) {
  mycopins <- get_community_data(transect, species)
  mycopins.env <- get_environment_data(transect, species)

  mycopins.env.variable <- data.frame(variable = mycopins.env[[variable]])

  alpha_indices <- diversity(mycopins,
                             index = index,
                             groups = mycopins.env.variable$variable)
  if (variable %in% c("Months", "Season", "Wood.Type", "Wood.Texture")) {
    alpha_index_df <- data.frame(Variable = names(alpha_indices),
                                 Alpha_Index = alpha_indices)
    alpha_index_df$Variable <- factor(alpha_index_df$Variable,
        levels = alpha_index_df$Variable[
          order(alpha_index_df$Variable)])
  } else {
    alpha_index_df <- data.frame(Variable = as.numeric(names(alpha_indices)),
                                 Alpha_Index = alpha_indices)
    alpha_index_df$Variable <- factor(alpha_index_df$Variable,
        levels = alpha_index_df$Variable[
          order(as.numeric(alpha_index_df$Variable))])
  }

  # Plot alpha diversity indices
  ggplot(alpha_index_df, aes(x = Variable ,
                         y = Alpha_Index,
                         fill = Variable)) +
    scale_fill_viridis(discrete = TRUE) +
    geom_bar(stat = "identity", color = "black") +
    geom_text(aes(label = round(Alpha_Index, 2)),
              position = position_stack(vjust = 1.05),
              color = "black", size = 3.5) +
    theme_minimal() +
    labs(x = variable,
         y = index,
         fill = variable) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}
