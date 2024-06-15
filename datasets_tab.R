source("env.R")

# UI for Datasets tab
datasetsTabUI <- function(id) {
  ns <- NS(id)
  tabItem(tabName = "datasets",
    navbarPage(title = "Datasets",
       tabPanel("Presence-Absence",
                downloadButton(ns("download_counts"), "Download"),
                hr(),
                DT::dataTableOutput(ns("dataset_counts"))),
       tabPanel("Organisms",
                downloadButton(ns("download_organisms"), "Download"),
                hr(),
                DT::dataTableOutput(ns("dataset_organisms")))
    )
  )
}

# Server logic for Datasets tab
datasetsTabServer <- function(id, transect, species) {
  moduleServer(id, function(input, output, session) {
    observe({
      #
      # Counts
      #
      mycopins <- get_community_data(transect, species)
      mycopins.env <- get_environment_data(transect, species)
      counts_df <- cbind(mycopins.env, mycopins)
      output$dataset_counts <- DT::renderDataTable({ counts_df },
                                           options = list(scrollX = TRUE))
      output$download_counts <- downloadHandler(
        filename = function() {
          paste("mycopins_counts_", transect, "_", species, "_", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
          write.csv(counts_df, file, row.names = FALSE)
        }
      )

      # Organisms
      #
      organisms_df <- get_organism_dataset(transect, species)
      output$dataset_organisms <- DT::renderDataTable({ organisms_df },
                                              options = list(scrollX = TRUE))
      output$download_organisms <- downloadHandler(
        filename = function() {
          paste("mycopins_organisms_", transect, "_", species, "_", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
          write.csv(organisms_df, file, row.names = FALSE)
        }
      )

    })
  })
}