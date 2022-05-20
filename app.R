install.packages('rgdal')
install.packages('leaflet')
install.packages('RColorBrewer')
install.packages('shinythemes')
install.packages('sp')
install.packages('maps')
install.packages('mapproj')
install.packages('mapdata')

## Load relevant R packages.
inLibraries = list('rgdal','leaflet', 'maptools', 'RColorBrewer',
                   'sp', 'maps', 'mapproj', 'mapdata',  'shiny', 'shinythemes')

for (rpack in inLibraries) {
  if (is.element(rpack,installed.packages()[,1])){
    #Load the library into R
    suppressMessages(library(rpack,character.only = TRUE))
  }
  else {
    print(paste("Warning:  ",rpack," is not an installed package"))
  }
}

mid_parcel <- readRDS ("data/mid_parcel_combined_rds2")

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
