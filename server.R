source("env.R")

if (!require("shiny")) install.packages("shiny")
if (!require("shinydashboard")) install.packages("shinydashboard")
if (!require("sodium")) install.packages("sodium")
library(shiny)
library(shinydashboard)
library(sodium)

source("alpha_diversity_tab.R")
source("beta_diversity_tab.R")
source("indicator_species_tab.R")
source("datasets_tab.R")

server = shinyServer(function(input, output, session) {
  pwd <- readBin("pwd.dat", "character", n=file.info("pwd.dat")$size)

  logged_in <- reactiveVal(FALSE)
  observeEvent(input$login, {
    if (logged_in() == FALSE) {
      showModal(modalDialog(
        title = "Enter Password",
        passwordInput("password", "Password"),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("login_button", "Log in")
        )
      ))
    } else {
      logged_in(ifelse(logged_in(), FALSE, TRUE))
    }
  })
  
  observeEvent(input$login_button, {
    if (password_verify(pwd, input$password)) {
      removeModal()
      logged_in(ifelse(logged_in(), FALSE, TRUE))
    }
  })
  
  output$logintext <- renderText({
    if(logged_in()) return("Logout")
    
    return("Login")
  })
  
  
  # Render the sidebar menu dynamically
  output$menu <- renderMenu({
    sidebarMenu(id = "sidebar",
    )
  })
  
  data_dir_list <- reactive({
    list.dirs(path = "./data", full.names = FALSE, recursive = FALSE)
  })
  
  observe({
    updateSelectInput(session, "transect",
                      choices = data_dir_list())
  })
  
  output$menuItems <- renderMenu({
    sidebarMenu({
      if (logged_in()) {
        tagList (
          # See https://shiny.posit.co/r/reference/shiny/0.12.0/icon.html for icons list
          menuItem("Alpha Diversity", tabName = "alphaDiversity", icon = icon("chart-simple")),
          menuItem("Beta Diversity", tabName = "betaDiversity", icon = icon("circle-nodes")),
          menuItem("Indicator Species Analysis", tabName = "indicatorSpecies", icon = icon("chart-column")),
          menuItem("Datasets", tabName = "datasets", icon = icon("table")),
          menuItem("Glossary", tabName = "glossary", icon = icon("book")),
          menuItem("References", tabName = "references", icon = icon("location-arrow")),
        )
      } else {
        tagList (
          # See https://shiny.posit.co/r/reference/shiny/0.12.0/icon.html for icons list
          menuItem("Alpha Diversity", tabName = "alphaDiversity", icon = icon("chart-simple")),
          menuItem("Beta Diversity", tabName = "betaDiversity", icon = icon("circle-nodes")),
          menuItem("Indicator Species Analysis", tabName = "indicatorSpecies", icon = icon("chart-column")),
          menuItem("Glossary", tabName = "glossary", icon = icon("book")),
          menuItem("References", tabName = "references", icon = icon("location-arrow")),
        )
      }
    })
  })
  
  observe({
    transect <- input$transect
    species <- input$species
    selectedTab <- input$mainTabs
    if (nchar(transect) > 0) {
      if (selectedTab == "alphaDiversity") {
        alphaDiversityTabServer("alphaDiversity", transect, species)
      }
      if (selectedTab == "betaDiversity") {
        betaDiversityTabServer("betaDiversity", transect, species)
      }
      if (selectedTab == "indicatorSpecies") {
        indicatorSpeciesTabServer("indicatorSpecies", transect, species)
      }
      if (selectedTab == "datasets") {
        datasetsTabServer("datasets", transect, species)
      }
    }
  })
  
})
