source("env.R")

source("plot_beta_ordination.R")
source("plot_beta_permanova.R")


# UI for Beta Diversity tab
betaDiversityTabUI <- function(id) {
  ns <- NS(id)
  tabItem(tabName = "betaDiversity",
    navbarPage(title = "Beta Diversity", id = ns("betaDiversityNavBar"),
      tabPanel("Ordination", value = "ordinationTab",
        sidebarLayout(
          sidebarPanel(
            selectInput(ns("ordination_environment_variables"),
                        label = "Environment Variable: ",
                        choices = NULL),
            selectInput(ns("ordination_method"), label = "Method: ",
                        choices = list("Bray" = "bray",
                                        "Jaccard" = "jaccard",
                                        "Manhattan" = "manhattan"),
                        selected = "bray"),
            selectInput(ns("draw"), label = "Draw: ",
                        choices = list("Ellipse" = "ellipse",
                                        "Hull" = "hull",
                                        "None" = "none"),
                        selected = "ellipse"),
            selectInput(ns("graph_type"), label = "Graph Type: ",
                        choices = list("Points" = "points",
                                        "Text" = "text",
                                        "None" = "none"),
                        selected = "none"),
            checkboxInput(ns("show_sites"),
                          label = "Show sites",
                          value = FALSE),
            checkboxInput(ns("show_species"),
                          label = "Show species",
                          value = FALSE),
            checkboxGroupInput(ns("show_vectors"), "Show vectors:", NULL)
          ),
          mainPanel(
            titlePanel(tags$h3("Non-metric multidimensional scaling (NMDS)",
                              style = "text-align: center;")),
            column(width = 12,
              tags$button(class = "btn btn-primary",
                          "data-toggle" = "collapse",
                          "data-target" = "#intro-ordination",
                          "Show Introduction"),
              tags$div(id = "intro-ordination",
                      class = "collapse",
                      includeMarkdown("./docs/ordination.md"))
            ),
            htmlOutput(ns("plot_label")),
            plotOutput(ns("nmds_plot"), width = "640px", heigh = "480px"),
            br(), br(),
            htmlOutput(ns("ano_label")),
            column(width = 12,
              tags$button(class = "btn btn-primary",
                          "data-toggle" = "collapse",
                          "data-target" = "#intro-anosim",
                          "Show Introduction"),
              tags$div(id = "intro-anosim",
                      class = "collapse",
                      includeMarkdown("./docs/analysis_of_similarities.md"))
            ),
            verbatimTextOutput(ns("nmds_ano"))
          )
        )
      ),
      tabPanel("PERMANOVA", value = "permanovaTab",
        sidebarLayout(
          sidebarPanel(width = 3,
          selectInput(ns("permanova_method"), label = "Method: ",
                      choices = list("Bray" = "bray",
                                     "Jaccard" = "jaccard",
                                     "Manhattan" = "manhattan"),
                      selected = "bray"),
          checkboxInput("show_model_formula",
                        label = "Show model formula",
                        value = FALSE),
          checkboxGroupInput(ns("permanova_predictors"), "Predictors:", NULL)
          ),
          mainPanel(
            titlePanel(tags$h3(
              "Permutational Multivariate Analysis of Variance (PERMANOVA)",
                              style = "text-align: center;")),
            column(width = 12,
              tags$button(class = "btn btn-primary",
                          "data-toggle" = "collapse",
                          "data-target" = "#intro-permanova",
                          "Show Introduction"),
              tags$div(id = "intro-permanova",
                      class = "collapse",
                      includeMarkdown("./docs/permanova.md")),
              hr()
            ),
            DT::dataTableOutput(ns("permanova")),
            conditionalPanel("input.show_model_formula==1",
                            h4("Model Formula"),
                            verbatimTextOutput(ns("model_formula")))
          )
        )
      )
    )
  )
}

# Server logic for Beta Diversity tab
betaDiversityTabServer <- function(id, transect, species) {
  moduleServer(id, function(input, output, session) {
    env_var <- get_environment_variables(transect, species)

    ordination_variables <-
      env_var[!(env_var %in% c("Sample.Number", "Tag", "Date.Collected"))]
    if (transect != "All") {
      ordination_variables <-
        env_var[!(env_var %in% c("Transect", "Sample.Number", "Tag", "Date.Collected"))]
    }
    updateSelectInput(session,
                      "ordination_environment_variables",
                      choices = ordination_variables)

    show_vectors_variables <- c("Days.Elapsed")
    updateCheckboxGroupInput(session,
                             "show_vectors",
                             choices = show_vectors_variables,
                             selected = show_vectors_variables)

    predictor_variables <-
      env_var[!(env_var %in% c("Transect", "Sample.Number", "Tag", "Date.Collected"))]
    updateCheckboxGroupInput(session,
                             "permanova_predictors",
                             choices = predictor_variables,
                             selected = c("Days.Elapsed", "Season", "Wood.Type", "avgtemp", "avghumidity"))

    observe({
      selectedPanel <- input$betaDiversityNavBar
      ordination_variable <- input$ordination_environment_variables
      ordination_method <- input$ordination_method
      permanova_method <- input$permanova_method
      permanova_predictors <- input$permanova_predictors

      if ("ordinationTab" == selectedPanel) {
        if (nchar(ordination_variable) > 0 &&
          (transect == "All" | ordination_variable != "Transect")) {

          draw <- input$draw
          graph_type <- input$graph_type
          show_sites <- input$show_sites
          show_species <- input$show_species
          show_vectors <- input$show_vectors

          nmds_analysis <- nmds(transect,
                                species,
                                ordination_variable,
                                ordination_method)

          if (length(nmds_analysis) == 5) {
            output$plot_label <- renderText(
              paste0("<h4><center>NMDS/", ordination_method, " - Stress = ",
                    format(round(nmds_analysis$mycopins.mds$stress, 4), nsmall = 4),
                    "</center></h4>")
            )
          }

          output$nmds_plot <- renderPlot({
            plot_nmds(nmds_analysis, ordination_variable, draw,
                      graph_type, show_sites, show_species, show_vectors)
          })

          output$ano_label <- renderText(
            "<h4><center>Analysis of similarities (ANOSIM)</center></h4>")
          output$nmds_ano <- renderText(nmds_analysis$mycopins.ano)
        }
      }

      if ("permanovaTab" == selectedPanel) {
        model <- generate_model("mycopins.dist", permanova_predictors)
        anova <- permanova(transect, species, permanova_method, model)
        output$permanova <- DT::renderDataTable({ anova })
        model <- generate_model("mycopins.dist", permanova_predictors, " +\n")
        output$model_formula <- renderText(( {model} ))
      }
    })
  })
}
