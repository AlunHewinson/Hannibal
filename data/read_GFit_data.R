library(RGoogleFit)
library(magrittr)
library(tidyverse)
library(glue)
#library(sp)
#library(leaflet)
#library(lubridate)

options(RGoogleFit.client_id=Sys.getenv("GFIT_CLIENT_ID"),
        RGoogleFit.client_secret=Sys.getenv("GFIT_CLIENT_SECRET"))

gfit_token <- GetFitOauth2Token()

## distance from steps, or so it seems!
GFit_distance <- GetFitDataset(
  gfit_token,
  "derived:com.google.distance.delta:com.google.android.gms:merge_distance_delta",
  as.POSIXct("2021-01-01 00:00:00"), as.POSIXct("2021-12-31 23:59:59")
)$point %>% as_tibble()
GFit_distance$value2 <- sapply(GFit_distance$value, function(q) q$fpVal)
GFit_distance %<>% mutate(start = NanosToPOSIXct(startTimeNanos),
                  end = NanosToPOSIXct(endTimeNanos),
                  date = as.Date(start),
                  cumvalue = cumsum(value2))

daily_dist <- GFit_distance %>% 
  group_by(date) %>% 
  summarise(distance=last(cumvalue))

glue("Distance travelled this year: {round(max(daily_dist$distance)/1000, 3)}km") %>%
  message()
