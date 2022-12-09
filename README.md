# Parcel Proximity Shiny App

This was a shiny visual I did as contribution to my group's capstone project, during my studies.

![](https://github.com/JasonSpaw/Parcel_Proximity_Shiny_App/blob/main/Capture.PNG)

- The app is an interactive leaflet map of Midland, Texas, highlighting only parcels that are within a distance, set by the user, from selected parcel types, which is also set by the user.  
- Ideally one would upload the app to shiny.io and provide the link for others to use, but I'm cheap and not paying to have it available on the server.  So for those who wish to view the app, follow the instructions below:
  1. Download RStudio.
  2. Download "mid_parcel_rds1" and "mid_parcel_rds2" from this repository.
  3. Open RStudio and start a new shiny web app: 
      - click (File > New File > Shiny Web Application)
      - add name, select "Single File (app.R)", and designate the directory for it to be created in
  4. Copy and paste the script found in "app.R" on this repository to your new Shiny web app in RStudio and save it.
  5. Create a new folder in the same location as your Shiny web app and name it "data".
  6. Copy and paste or move "mid_parcel_rds1" and "mid_parcel_rds2" from downloads to the data folder you just created.
  7. Go back to RStudio and press the Run App button in the top right corner of your Shiny web app.
    - After the first run, or if you are not new to RStudio and already have the needed packages installed, add "#" to the start of each line that has "install.packages" so you are not reinstalling the packages (the app will start faster).
