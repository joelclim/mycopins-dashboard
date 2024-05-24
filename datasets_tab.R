source("env.R")

# UI for Datasets tab
datasetsTabUI <- function(id) {
  ns <- NS(id)
  tabItem(tabName = "datasets",
    navbarPage(title = "Datasets",
       tabPanel("Counts",
                downloadButton(ns("download_counts"), "Download"),
                hr(),
                DT::dataTableOutput(ns("dataset_counts"))),
       tabPanel("GBIF Taxonomy",
                downloadButton(ns("download_gbif_taxonomy"), "Download"),
                hr(),
                DT::dataTableOutput(ns("dataset_gbif_taxonomy"))),
       tabPanel("Fungal Traits",
                downloadButton(ns("download_fungal_traits"), "Download"),
                hr(),
                DT::dataTableOutput(ns("dataset_fungal_traits")))
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

      # GBIF Taxonomy
      #
      gbif_taxon_df <- get_gbif_taxon_data(transect, species)
      output$dataset_gbif_taxonomy <- DT::renderDataTable({ gbif_taxon_df },
                                              options = list(scrollX = TRUE))
      output$download_gbif_taxonomy <- downloadHandler(
        filename = function() {
          paste("mycopins_gbif_taxon_", transect, "_", species, "_", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
          write.csv(gbif_taxon_df, file, row.names = FALSE)
        }
      )

      # Fungal Traits
      #
      fungal_traits_df <- get_fungal_traits_data(transect, species)
      output$dataset_fungal_traits <- DT::renderDataTable({ fungal_traits_df },
                                              options = list(scrollX = TRUE))
      output$download_fungal_traits <- downloadHandler(
        filename = function() {
          paste("mycopins_genus_traits_", transect, "_", species, "_", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
          write.csv(fungal_traits_df, file, row.names = FALSE)
        }
      )

    })
  })
}