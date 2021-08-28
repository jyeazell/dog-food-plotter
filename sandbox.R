library(tidyr)
library(dplyr)
library(rvest)
library(stringr)
library(ggplot2)


my_url <- "https://www.hillspet.com/dog-food/sd-canine-puppy-large-breed-lamb-meal-brown-rice-recipe-dry"

page_info <- read_html(my_url)

feeding_amounts_raw <- page_info %>% 
  html_element("table") %>% 
  html_table(na.strings = "")

names(feeding_amounts_raw) <- c("dog_wt",
                           "age_00_04",
                           "age_04_09",
                           "age_10_12",
                           "age_13_18")

feeding_amounts <- feeding_amounts_raw %>% 
  pivot_longer(cols = starts_with("age"),
               names_to = "puppy_age",
               values_to = "feed_amt") %>% 
  drop_na()

feeding_amounts <- feeding_amounts %>% 
  separate(col = dog_wt,
           into = c("dog_wt_lb",
                    "dog_wt_kg"),
           sep = " ",
           remove = FALSE) %>% 
  mutate(dog_wt_lb = as.numeric(dog_wt_lb)) %>% 
  separate(col = feed_amt,
           into = c("feed_amt_cups", "feed_amt_g"),
           sep = " (?=[^ ]*$)",
           remove = FALSE)

feeding_amounts <- feeding_amounts %>%  
  mutate(feed_amt_g = as.numeric(str_replace_all(string = feed_amt_g, 
                                  pattern = "\\(|\\)",
                                  replacement = "")))


# make plot. ----
g <- ggplot(data = feeding_amounts,
            mapping = aes(x = dog_wt_lb,
                          y = feed_amt_g,
                          color = puppy_age)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks = seq(from = 0, 
                                  to = max(feeding_amounts$dog_wt_lb), 
                                  by = 10)) +
  scale_y_continuous(breaks = seq(from = 0, 
                                 to = max(feeding_amounts$feed_amt_g), 
                                 by = 100)) +
  scale_color_discrete(name = "Puppy's Age",
                       breaks = unique(feeding_amounts$puppy_age),
                       labels = c("0 though 3 Months",
                                  "4 through 9 Months",
                                  "10 through 12 Months",
                                  "13 through 18 Months")) +
  labs(title = "Puppy Feeding Schedule",
       subtitle = "Hill's Science Diet Puppy Large Breed Lamb Meal & Brown Rice Recipe") +
  xlab("Puppy's Weight in Pounds") +
  ylab("Daily Amount of Food in Grams") +
  theme_minimal()
g
  

