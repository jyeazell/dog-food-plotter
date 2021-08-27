library(tidyr)
library(dplyr)
library(rvest)


my_url <- "https://www.hillspet.com/dog-food/sd-canine-puppy-large-breed-lamb-meal-brown-rice-recipe-dry"

page_info <- read_html(my_url)

feeding_amounts <- page_info %>% 
  html_element("table") %>% 
  html_table()
