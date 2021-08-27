library(tidyr)
library(dplyr)
library(rvest)


my_url <- "https://www.hillspet.com/dog-food/sd-canine-puppy-large-breed-lamb-meal-brown-rice-recipe-dry"

page_info <- read_html(my_url)

feeding_amounts <- page_info %>% 
  html_element("table") %>% 
  html_table(na.strings = "")

names(feeding_amounts) <- c("dog_wt",
                           "age_00_04",
                           "age_04_09",
                           "age_10_12",
                           "age_13_18")

feeding_amounts <- feeding_amounts %>% 
  pivot_longer(cols = starts_with("age"),
               names_to = "puppy_age",
               values_to = "feed_amt") %>% 
  drop_na()

feeding_amounts_t <- feeding_amounts %>% 
  separate(col = dog_wt,
           into = c("dog_wt_lb",
                    "dog_wt_kg"),
           sep = " ",
           remove = FALSE)
  