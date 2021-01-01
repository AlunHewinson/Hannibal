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
tbroute %>% print()

tbroute %>% write_csv("data/route_Europe.csv")
