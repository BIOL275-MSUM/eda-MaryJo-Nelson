
# Load Packages -----------------------------------------------------------

library(tidyverse)
library(readxl)
library(lubridate)
library(sf)
library(cowplot)
library(googleway)
library(ggrepel)
library(ggspatial)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
library(sp)

theme_set(theme_bw())

# Observations Data ----------------------------------------------------------

(ob <- read_excel("Bird Survey Data/observations.xlsx") %>%
   select(-dttm_created))
(ob_sna <- read_excel("Bird Survey Data/observations_sna.xlsx"))


# Survey Data -------------------------------------------------------------

(sur <- read_excel("Bird Survey Data/surveys.xlsx") %>%
   filter(!is_shadow) %>%
   select(-dttm_created))

# Point Data --------------------------------------------------------------

(pts <- read_excel("Bird Survey Data/points.xlsx") %>%
   select(-dttm_created) %>%
   select(-lat, -long))
(pc <- read_excel("Bird Survey Data/point_coverage.xlsx") %>%
    select(-transect_name, -point_num))

# Observer Data -----------------------------------------------------------

(observer <- read_excel("Bird Survey Data/observers.xlsx") %>%
   select(-dttm_created))

# Species Data ------------------------------------------------------------

(sp <- read_excel("Bird Survey Data/species.xlsx"))

# Join Bird Data Tables ---------------------------------------------------

d <-
  sur %>% 
  left_join(pts, by = "point_id") %>%
  left_join(pc, by = "point_id") %>% 
  left_join(ob, by = "survey_id") %>% 
  left_join(observer, by = "observer_id") %>% 
  left_join(sp, by = "species_id") %>%
  pivot_longer(cols = c(n_0_50, n_50_100, n_100_), names_to="distance", values_to="n_indiv") %>%
  filter(!is.na(n_indiv)) %>%
  uncount(weights = n_indiv)

(d <- select(d, point_id, transect_name, PRIMARY_COM_NAME, survey_date, survey_time,distance, observation_notes, data_entry_notes,
             observer_name, herbaceous, shrub, forest, river, bare, wind_speed_mean, temp, cloud_cov) %>%
    mutate(point_id = as_factor(point_id))
    )

    



# Filter out unknown bird species -----------------------------------------

(abc <- filter(d, !(PRIMARY_COM_NAME == "bird sp."), !(PRIMARY_COM_NAME == "NA")))

(species <- count(abc, PRIMARY_COM_NAME))


# Filter by year ----------------------------------------------------------

(nineteen <- filter(abc, str_detect(survey_date, "2019-")))
(n_sp_cnt <- count(nineteen, PRIMARY_COM_NAME))

(eighteen <- filter(abc, str_detect(survey_date, "2018-")))
(e_sp_cnt <- count(eighteen, PRIMARY_COM_NAME))

(abc_c <- filter(abc, observer_name == "Chris"))

# Filter by Transect ------------------------------------------------------



# Filter Black-billed Cuckoo ------------------------------------------------

(bbc <- filter(abc, PRIMARY_COM_NAME == "Black-billed Cuckoo")) 

(bbc_pts <- count(bbc, point_id))

(bbc_19 <- filter(bbc, str_detect(survey_date, "2019-")))
(bbc_18 <- filter(bbc, str_detect(survey_date, "2018-")))



# BBC observer count

(bbc_o <- count(bbc, observer_name))


# MAP ATTEMPT -------------------------------------------------------------

#failure
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

ggplot(data = world) +
  geom_sf() +
  coord_sf(xlim = c(-96.48, -96.42), ylim = c(46.85, 46.88), expand = FALSE)

#this works, but find a way to get satellite imagery underneath
ggplot(data = pts) +
  geom_jitter(mapping = aes(x = long, y = lat, color = transect_name))

# GRAPHS ------------------------------------------------------------------

# Bar graph, observation frequency per day

#2019
ggplot(data = nineteen) +
  geom_bar(mapping = aes(x = survey_date))

#2018
ggplot(data = eighteen) +
  geom_bar(mapping = aes(x = survey_date))


# Scatter Plot, point id vs. date -----------------------------------------

# 2019
ggplot(data = nineteen) +
  geom_jitter(mapping = aes(x = survey_date, y = point_id, color = transect_name, shape = observer_name), 
              size = 1, alpha = .25)

# 2018
ggplot(data = eighteen) +
  geom_jitter(mapping = aes(x = survey_date, y = point_id, color = transect_name, shape = observer_name), 
              size = 1, alpha = .25)

# Scatter Plot, point id vs species -----------------------------------------

#all
ggplot(data = abc) +
  geom_jitter(mapping = aes(x = PRIMARY_COM_NAME, y = point_id, color = survey_time), alpha = .2) +
  labs(x = "Point ID", y = "Species (common name)", title = "Species Point Distribution, all years") +
  theme(
    axis.text.x = element_text(angle = 45, size = rel(.5))
  )

# 2019

ggplot(data = nineteen) +
  geom_jitter(mapping = aes(x = PRIMARY_COM_NAME, y = point_id, color = point_id, 
                            shape = point_id), color = "#3EA99F", shape = 1, alpha = .5) +
  labs(x = "Species (common name)", y = "Point ID", title = "Species Point Distrubution 2019") +
  theme(
    axis.text.x = element_text(angle = 45, size = rel(.5))
  )

# 2018

ggplot(data = eighteen) +
  geom_jitter(mapping = aes(x = PRIMARY_COM_NAME, y = point_id, color = point_id, 
                            shape = point_id), color = "#347235", shape = 1, alpha = .5) +
  labs(x = "Species (common name)", y = "Point ID", title = "Species Point Distribution 2018") +
  theme(
    axis.text.x = element_text(angle = 45, size = rel(.5))
  )

# Scatter Plot species vs time

ggplot(data = abc) +
  geom_jitter(mapping = aes(x = survey_time, y = PRIMARY_COM_NAME), 
              alpha = .2) +
  theme(
    axis.text.x = element_text(angle = 45, size = rel(.5))
  )

# Line Graph, survey time

ggplot(data = d) +
  geom_line(mapping = aes(x = survey_time, y = PRIMARY_COM_NAME))

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

#all

ggplot(data = abc) +
  geom_bar(mapping = aes(x = point_id))

#2019

ggplot(data = nineteen) +
  geom_bar(mapping = aes(x = point_id))

#2018

ggplot(data = eighteen) +
  geom_bar(mapping = aes(x = point_id))

# Scatter Plot of Observers vs Point id

ggplot(data = d) +
  geom_jitter(mapping = aes(x = observer_name, y = point_id, 
                            color = observer_name), alpha = .2) +
  theme(
    axis.text.x = element_text(angle = 45)
  )



# Black-billed Cuckoo point distribution ----------------------------------

ggplot(data = bbc) +
  geom_bar(mapping = aes(x = point_id))  

ggplot(data = bbc) +
  geom_jitter(mapping = aes(x = point_id, y = PRIMARY_COM_NAME))  #need to fix this somehow

# dates of all Black-billed Cuckoo observations
ggplot(data = bbc) +
  geom_jitter(mapping = aes(x = survey_date, y = point_id, color = transect_name, 
                            shape = observer_name))

# dates of Merkords observations
ggplot(data = abc_c) +
  geom_jitter(mapping = aes(x = survey_date, y = point_id, color = transect_name))

# Black-billed Cuckoo Observers

ggplot(data = bbc) +
  geom_jitter(mapping = aes(x = observer_name, y = point_id, 
                            color = observer_name), alpha = .5) +
  theme(
    axis.text.x = element_text(angle = 45)
  )

# Time observed bbc

ggplot(data = bbc) +
  geom_jitter(mapping = aes(x = point_id, y = survey_time, color = observer_name),
              alpha = .5)


# BAR GRAPHS, environmental factors ---------------------------------------

#herbaceous
ggplot(data = bbc) +
  geom_bar(mapping = aes(x = herbaceous)) +
  scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
  scale_y_continuous(breaks = seq(0, 6, 1), limits = c(0, 6))

#shrub
ggplot(data = bbc) +
  geom_bar(mapping = aes(x = shrub)) +
  scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
  scale_y_continuous(breaks = seq(0, 6, 1), limits = c(0, 6))

#forest
ggplot(data = bbc) +
  geom_bar(mapping = aes(x = forest)) +
  scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
  scale_y_continuous(breaks = seq(0, 6, 1), limits = c(0, 6))

#river
ggplot(data = bbc) +
  geom_bar(mapping = aes(x = river)) +
  scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
  scale_y_continuous(breaks = seq(0, 6, 1), limits = c(0, 6))

#bare
ggplot(data = bbc) +
  geom_bar(mapping = aes(x = bare)) +
  scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
  scale_y_continuous(breaks = seq(0, 6, 1), limits = c(0, 6))

