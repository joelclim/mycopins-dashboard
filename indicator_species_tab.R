source("env.R")

indicator_values <- function(transect, species, variable) {
  mycopins <- get_community_data(transect, species)
  mycopins.env <- get_environment_data(transect, species)
  mycopins.groups <- mycopins.env[[variable]]

  indval_results <- indval(mycopins, mycopins.groups, permutations = 1000)

  indval_df <- data.frame(indval_results$indval)
  groups <- names(indval_df)[indval_results$maxcls]

  values <- c()
  for (row in 1:length(indval_results$maxcls)) {
    col <- indval_results$maxcls[row]
    values <- c(values, indval_results$relfrq[row, col])
  }
  frqs <- data.frame(Frequency = values)

  values <- c()
  for (row in 1:length(indval_results$maxcls)) {
    col <- indval_results$maxcls[row]
    values <- c(values, indval_results$relabu[row, col])
  }
  abus <- data.frame(Abundance=values)

  indicator_values_df <- data.frame(Group=groups,
                           round(frqs, 6),
                           round(abus, 6),
                           Indicator.Value = round(indval_results$indcls, 6),
                           P_value = round(indval_results$pval, 6))
  names(indicator_values_df)[names(indicator_values_df) == "Group"] <- variable

  return(indicator_values_df)
}


# UI for Indicator Species tab
indicatorSpeciesTabUI <- function(id) {
  ns <- NS(id)
  tabItem(tabName = "indicatorSpecies",
    sidebarLayout(
      sidebarPanel(width = 3,
        selectInput(ns("indicator_species_env_var"),
                    label = "Environment Variable: ",
                    choices = NULL)
      ),
      mainPanel(
        titlePanel(
          tags$h3("Indicator Species Analysis", style = "text-align: center;")
        ),
        column(width = 12,
          tags$button(class = "btn btn-primary",
                      "data-toggle" = "collapse",
                      "data-target" = "#intro-isa",
                      "Show Introduction"),
          tags$div(id = "intro-isa",
                  class = "collapse",
                  includeMarkdown("./docs/indicator_species_analysis.md"))
        ),
        DT::dataTableOutput(ns("indicator_values"))
      )
    )
  )
}

# Server logic for Indicator Species tab
indicatorSpeciesTabServer <- function(id, transect, species) {
  moduleServer(id, function(input, output, session) {

    environment_variables <- get_environment_variables(transect,
      species, c("Sample.Number", "Tag", "Date.Collected"))
    updateSelectInput(session,
                      "indicator_species_env_var",
                      choices = environment_variables)

    observe({
      variable <- input$indicator_species_env_var

      if (nchar(variable) > 0) {
        indicator_values_df <- indicator_values(transect, species, variable)
        output$indicator_values <- DT::renderDataTable({ indicator_values_df },
                                    options = list(scrollX = TRUE))
      }
    })
  })
}