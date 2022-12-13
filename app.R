# Install required packages
install.packages('rgdal', repos = "http://cran.us.r-project.org")
install.packages('leaflet', repos = "http://cran.us.r-project.org")
install.packages('RColorBrewer', repos = "http://cran.us.r-project.org")
install.packages('shiny', repos = "http://cran.us.r-project.org")
install.packages('shinythemes', repos = "http://cran.us.r-project.org")
install.packages('sp', repos = "http://cran.us.r-project.org")
install.packages('maps', repos = "http://cran.us.r-project.org")
install.packages('mapproj', repos = "http://cran.us.r-project.org")
install.packages('mapdata', repos = "http://cran.us.r-project.org")

## Load relevant R packages.
library('rgdal')
library('leaflet')
library('maptools')
library('shiny')
library('RColorBrewer')
library('shinythemes')
library('sp')
library('maps')
library('mapproj')
library('mapdata')

mid_1 <- readRDS ("data/mid_parcel_rds1")
mid_2 <- readRDS ("data/mid_parcel_rds2")

mid_parcel <- rbind(mid_1,mid_2)

locations <- c("Non-Categorized Parcels" = "none",
               "General sales or services" = "General sales or services", 
               "Households" = "Private household",  
               "Recreational parks" = "Natural and other recreational parks",
               "Manufacturing and wholesale trade" = "Manufacturing and wholesale trade",
               "Agriculture, forestry, fishing and hunting" = "Agriculture, forestry, fishing and hunting", 
               "Telecommunications and broadcasting" = "Telecommunications and broadcasting", 
               "Electric power" = "Electric power",
               "Natural gas, petroleum, fuels, etc." = "Natural gas, petroleum, fuels, etc.")

dist_from <- list("Agriculture, forestry, fishing and hunting" = 'dist_Ag_forest',
                  "Alfalfa" = 'dist_Alfalfa',
                  "Cotton" = 'dist_Cotton',
                  "High developement" = 'dist_Dev_High',
                  "Medium developement" = 'dist_Dev_Med',
                  "Low developement" = 'dist_Dev_Low',
                  "Open space developement" = 'dist_Dev_OS',
                  "Electric power" = 'dist_E_Power',
                  "Natural gas, petroleum, fuels, etc." = 'dist_natural_gas',
                  "Natural resources-related" = 'dist_natural_res',
                  "Other Hay/Non Alfalfa" = 'dist_Other_Hay',
                  "Recreational parks" = 'dist_rec_parks',
                  "Sorghum" = 'dist_Sorghum',
                  "Telecommunications and broadcasting" = 'dist_Tele_Broad',
                  "Manufacturing and wholesale trade" = 'dist_Wholesale',
                  "Winter wheat" = 'dist_Winter_Wheat',
                  "Woody Wetlands" = 'dist_Woody_Wet',
                  "General sales or services" = 'dist_shop',
                  "Elementary School" = 'elem_dist',
                  "Middle School" = 'middle_dist',
                  "High School" = 'high_dist')

Spawta_ui <- fluidPage(
  theme=shinytheme("superhero"),
  titlePanel("Location, Location"),
  tabsetPanel(
    tabPanel("Overview",
             tags$h2("How to use this app"),
             tags$p("Description!"),
    ), 
    tabPanel("Desired Proxities",
             sidebarLayout(
               sidebarPanel(
                 checkboxGroupInput("Property_types", label=h4("Property types:"), 
                                    choices=locations,
                                    selected=c("Private household")),
                 selectInput("Proximity_to", label = h4("Proximity to:"), 
                             choices = dist_from, selected = c('high_dist')),
                 sliderInput("Within_radius",label=h4("Within radius of (meters):"),min=25,max=5000,value=50),
               ),
               mainPanel(tags$h2("Properties within desired radius:"),
                         leafletOutput("map"),
                         tags$h3("Are the properties you are looking to invest in within proximity of your needs?"),
                         tags$div(
                           HTML(paste("Let us help you by narrowing your search to only properties that fit your needs.  Use our",
                                      " proximity tool to help find the best location for your next investment.", sep="")))
               )
             )
    )))


plot_server <- function(input, output, session){ 
  
  output$map <- renderLeaflet ({   
    
    sub <- mid_parcel[which(mid_parcel@data$lbcs_fun_1 %in% input$Property_types & mid_parcel@data[,input$Proximity_to] <= input$Within_radius),]
    
    # Midland County, TX coordinates found using Google (-102.0779, 31.9973).
    leaflet(sub) %>% addTiles() %>% setView(-102.0779, 31.9973, zoom = 9) %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.5,
                  fillColor = "lightgreen") 
  })
  
}

shinyApp(ui=Spawta_ui, server=plot_server)
