source("env.R")

source("plot_alpha_species_richness.R")
source("plot_alpha_diversity_index.R")
source("plot_alpha_species_frequency.R")

# UI for Alpha tab
alphaDiversityTabUI <- function(id) {
  ns <- NS(id)
  tabItem(tabName = "alphaDiversity",
    navbarPage(title = "Alpha Diversity",
      tabPanel("Species Richness",
        sidebarLayout(
          sidebarPanel(width = 3,
            selectInput(ns("species_richness_variables"),
                        label = "Environment Variable: ",
                        choices = NULL)),
          mainPanel(
            plotOutput(ns("species_richness_plot"),
                       width = "640px", heigh = "480px"),
            DT::dataTableOutput(ns("species_richness_summary")))
        )
      ),
      tabPanel("Diversity Index",
        sidebarLayout(
          sidebarPanel(width = 3,
            selectInput(ns("alpha_diversity_index"),
                        label = "Diversity Index: ",
                        choices = list("Shannon" = "shannon",
                                       "Simpson's" = "simpson"),
                        selected = "shannon"),
            selectInput(ns("alpha_diversity_variables"),
                        label = "Environment Variable: ",
                        choices = NULL)),
          mainPanel(
            plotOutput(ns("alpha_diversity_plot"),
                      width = "640px", heigh = "480px"))
        )
      ),
      tabPanel("Species Frequency",
               DT::dataTableOutput(ns("species_frequency_plot"))
      ),
    )
  )
}


# Server logic for Alpha Diversity tab
alphaDiversityTabServer <- function(id, transect, species) {
  moduleServer(id, function(input, output, session) {
    species_richness_variables <- get_environment_variables(transect,
      species, c("Sample.Number", "Tag", "Date.Collected"))
    updateSelectInput(session,
                      "species_richness_variables",
                      choices = species_richness_variables)

    alpha_diversity_variables <- get_environment_variables(transect,
      species, c("Transect", "Sample.Number", "Tag", "Date.Collected"))
    updateSelectInput(session,
                      "alpha_diversity_variables",
                      choices = alpha_diversity_variables)
    observe({
      if (nchar(input$species_richness_variables) > 0) {
        species_richness <- get_species_richness(transect,
                                                 species,
                                                 input$species_richness_variables)
        output$species_richness_plot <- renderPlot({
          plot_species_richness(species_richness,
                                input$species_richness_variables)
        })
        output$species_richness_summary <- DT::renderDataTable({
          summarize_species_richness(species_richness,
                                     input$species_richness_variables)
        })
      }

      if (nchar(input$alpha_diversity_variables) > 0) {
        output$alpha_diversity_plot <- renderPlot({
          plot_alpha_diversity(transect, species,
                               input$alpha_diversity_variables,
                               input$alpha_diversity_index)
        })
      }

      output$species_frequency_plot <- DT::renderDataTable({
        plot_alpha_species_frequency(transect, species)
      })
    })
  })
}
