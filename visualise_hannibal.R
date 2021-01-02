source("data/read_GFit_data.R")
routeE <- read_csv("data/route_Europe.csv", col_types = "dddd", progress = FALSE)
routeA <- read_csv("data/route_Africa.csv", col_types = "dddd", progress = FALSE)
routeA$cdist <- routeA$cdist + max(routeE$cdist)

coveredE <- routeE %>% filter(cdist <= max(daily_dist$distance))
coveredA <- routeA %>% filter(cdist <= max(daily_dist$distance))

lf <- leaflet() %>% 
  #addTiles() %>%
  #addProviderTiles("Esri.DeLorme") %>% 
  addProviderTiles("Stamen.Watercolor") %>% 
  addPolylines(routeE$lon, routeE$lat, color="#000", weight=6, opacity=0.55) %>% 
  addPolylines(routeA$lon, routeA$lat, color="#000", weight=6, opacity=0.55) %>% 
  addPolylines(coveredE$lon, coveredE$lat, color="#0f0", weight=3, opacity=1) %>% 
  addPolylines(coveredA$lon, coveredA$lat, color="#0f0", weight=3, opacity=1)
lf %>% print()

message(glue("Total route              {round(max(routeA$cdist))}m"))
message(glue("Distance covered         {round(max(daily_dist$distance))}m"))
message(glue("Today's date             {today()}"))
message(glue("Today's target distance  {round(max(routeA$cdist)/365*as.numeric(today()-as.Date('2020-12-31')))}m"))
message(glue("Route completed          {round(100 * max(daily_dist$distance) / max(routeA$cdist), 2)}%"))
message(glue("Current position         {paste(tail(coveredE, 1)[, 2:1], collapse=',')}"))
