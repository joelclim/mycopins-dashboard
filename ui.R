## ui.R ##
source("env.R")

if (!require("markdown")) install.packages("markdown")
if (!require("shiny")) install.packages("shiny")
if (!require("shinydashboard")) install.packages("shinydashboard")

library(markdown)
library(shiny)
library(shinydashboard)

source("alpha_diversity_tab.R")
source("beta_diversity_tab.R")
source("indicator_species_tab.R")
source("datasets_tab.R")

ui <- dashboardPage(
  dashboardHeader(
    title = "MycoPins",
    tags$li(class = "dropdown",
            tags$li(class = "dropdown",
                    actionLink("login", textOutput("logintext"))))
  ),
  dashboardSidebar(
    sidebarMenu(id = "mainTabs", width = "70",
      selectInput("transect", label = "Transect: ", choices = NULL),
      selectInput("species", label = "Species: ",
                  choices = list("All" = 1,
                                 "Fungi" = 2),
                  selected = 2),
      sidebarMenuOutput("menuItems")
    )
  ),
  dashboardBody(
    tabItems(
      alphaDiversityTabUI("alphaDiversity"),
      betaDiversityTabUI("betaDiversity"),
      indicatorSpeciesTabUI("indicatorSpecies"),
      datasetsTabUI("datasets"),
      tabItem(tabName = "glossary",
              includeMarkdown("./docs/glossary.md")),
      tabItem(tabName = "references",
              includeMarkdown("./docs/references.md"))
    )
  )
)