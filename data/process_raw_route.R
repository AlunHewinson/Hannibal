library(magrittr)
library(tidyverse)
library(geosphere)

rawroute <- readLines("data/route_Spain_France_Italy.txt")
tbroute <- rawroute %>% 
  strsplit(" |,") %>% 
  unlist() %>% 
  magrittr::extract(c(T,T,F)) %>% 
  matrix(2) %>% 
  t() %>% 
  as.data.frame() %>% 
  set_colnames(c("lon", "lat")) %>% 
  as_tibble() %>% 
  mutate_all(as.numeric)

distances <- distGeo(tbroute) %>% 
  c(0, .) %>% rev() %>% magrittr::extract(-1) %>% rev()
tbroute$dist <- distances
tbroute$cdist <- cumsum(distances)
#tbroute %>% print()
# tbroute %>%
#   slice() %>% 
#   select(lon, lat) %>% plot(xlim=c(15, 16), ylim=c(38, 38.5))

tbroute %>% write_csv("data/route_Europe.csv")



