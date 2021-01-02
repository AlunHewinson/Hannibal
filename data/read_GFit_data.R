library(RGoogleFit, quietly = TRUE)
library(magrittr, quietly = TRUE)
library(tidyverse, quietly = TRUE)
library(glue, quietly = TRUE)
library(leaflet, quietly = TRUE)
library(lubridate, quietly = TRUE)

options(RGoogleFit.client_id=Sys.getenv("GFIT_CLIENT_ID"),
        RGoogleFit.client_secret=Sys.getenv("GFIT_CLIENT_SECRET"))

gfit_token <- GetFitOauth2Token()

quiet <- function(x) {
  sink(tempfile())
  on.exit(sink())
  invisible(force(x))
}

## distance from Google Fit
GFit_distance <- quiet(GetFitDataset(
  gfit_token,
  "derived:com.google.distance.delta:com.google.android.gms:merge_distance_delta",
  as.POSIXct("2021-01-01 00:00:00"), as.POSIXct("2021-12-31 23:59:59")
))$point %>% as_tibble()
GFit_distance$value2 <- sapply(GFit_distance$value, function(q) q$fpVal)
GFit_distance %<>% mutate(start = NanosToPOSIXct(startTimeNanos),
                  end = NanosToPOSIXct(endTimeNanos),
                  date = as.Date(start),
                  cumvalue = cumsum(value2))

daily_dist <- GFit_distance %>% 
  group_by(date) %>% 
  summarise(distance=last(cumvalue), .groups="drop")
