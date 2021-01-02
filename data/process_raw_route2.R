library(magrittr)
library(tidyverse)
library(geosphere)

rawroute <- readLines("data/route_Tunisia.txt")
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

tbroute %>% write_csv("data/route_Africa.csv")



