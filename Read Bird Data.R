
# Load Packages -----------------------------------------------------------

library(tidyverse)
library(readxl)
library(lubridate)
library(sf)



# Observations Data ----------------------------------------------------------

(ob <- read_excel("Bird Survey Data/observations.xlsx"))
(ob_sna <- read_excel("Bird Survey Data/observations_sna.xlsx"))


# Survey Data -------------------------------------------------------------

(sur <- read_excel("Bird Survey Data/surveys.xlsx"))

# Point Data --------------------------------------------------------------

(pts <- read_excel("Bird Survey Data/points.xlsx"))
(pc <- read_excel("Bird Survey Data/point_coverage.xlsx"))

# Observer Data -----------------------------------------------------------

(observer <- read_excel("Bird Survey Data/observers.xlsx"))

# Species Data ------------------------------------------------------------

(sp <- read_excel("Bird Survey Data/species.xlsx"))

# Join Bird Data Tables ---------------------------------------------------

d <-
  pts %>% 
  select(-dttm_created) %>% 
  left_join(sur, by = "point_id") %>% 
  select(-dttm_created) %>% 
  select(-lat, -long) %>%
  left_join(ob, by = "survey_id") %>% 
  select(-dttm_created) %>% 
  left_join(observer, by = "observer_id") %>% 
  select(-dttm_created) %>% 
  left_join(sp, by = "species_id") %>% 
  print()



# Filter out unknown bird species -----------------------------------------

(abc <- filter(d, !(PRIMARY_COM_NAME == "bird sp."), !(PRIMARY_COM_NAME == "NA")))

(species <- count(abc, PRIMARY_COM_NAME))


# Filter by year ----------------------------------------------------------

(nineteen <- filter(abc, str_detect(survey_date, "2019-"))) 

(eighteen <- filter(abc, str_detect(survey_date, "2018-")))



# Filter Black-billed Cuckoo ------------------------------------------------

(bbc <- filter(abc, PRIMARY_COM_NAME == "Black-billed Cuckoo")) 

(bbc_pts <- count(bbc, point_id))


# GRAPHS ------------------------------------------------------------------

# Scatter Plot, point id vs species -----------------------------------------

#all
ggplot(data = abc) +
  geom_jitter(mapping = aes(x = PRIMARY_COM_NAME, y = point_id, color = point_id, 
                            shape = point_id), shape = 1, alpha = .5) +
  labs(x = "Point ID", y = "Species (common name)") +
  theme(
    axis.text.x = element_text(angle = 45, size = rel(.5))
  )

# 2019

ggplot(data = nineteen) +
  geom_jitter(mapping = aes(x = PRIMARY_COM_NAME, y = point_id, color = point_id, 
                            shape = point_id), shape = 1, alpha = .5) +
  labs(x = "Point ID", y = "Species (common name)") +
  theme(
    axis.text.x = element_text(angle = 45, size = rel(.5))
  )

# 2018

ggplot(data = eighteen) +
  geom_jitter(mapping = aes(x = PRIMARY_COM_NAME, y = point_id, color = point_id, 
                            shape = point_id), shape = 1, alpha = .5) +
  labs(x = "Point ID", y = "Species (common name)") +
  theme(
    axis.text.x = element_text(angle = 45, size = rel(.5))
  )

# Bar graph, species frequency --------------------------------------------

#all
ggplot(data = abc) +
  geom_bar(mapping = aes(y = fct_infreq(PRIMARY_COM_NAME))) +
  theme(
    axis.text = element_text(color = "black", size = 5)
  )

# 2019

ggplot(data = nineteen) +
  geom_bar(mapping = aes(y = fct_infreq(PRIMARY_COM_NAME))) +
  theme(
    axis.text = element_text(color = "black", size = 5))

# 2018

ggplot(data = eighteen) +
  geom_bar(mapping = aes(y = fct_infreq(PRIMARY_COM_NAME))) +
  theme(
    axis.text = element_text(color = "black", size = 5))


# Bar graph, frequency of birds sighted at each point ---------------------

ggplot(data = abc) +
  geom_bar(mapping = aes(x = point_id))


# Black-billed Cuckoo point distribution ----------------------------------

ggplot(data = bbc) +
  geom_bar(mapping = aes(x = point_id)) 

ggplot(data = bbc_pts) +
  geom_jitter(mapping = aes(x = point_id, y = n))
           
           
           
           