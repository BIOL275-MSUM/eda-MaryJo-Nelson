
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
library(suncalc)


theme_set(theme_bw())

# Observations Data ----------------------------------------------------------

(ob <- read_excel("Bird Survey Data/observations.xlsx") %>%
   select(-dttm_created))
(ob_sna <- read_excel("Bird Survey Data/observations_sna.xlsx"))


# Survey Data -------------------------------------------------------------

(sur <- read_excel("Bird Survey Data/surveys.xlsx") %>%
   filter(!is_shadow) %>%
   select(-dttm_created) %>%
   mutate(
     survey_date = date(survey_date),
     # survey_dttm = paste(
     #   as.character(survey_date),
     #   as.character(survey_time) %>% 
     #     str_sub(12, 19)
     # ) %>% 
     #   as_datetime(),
     survey_mss = hour(survey_time)*60 + minute(survey_time) - 330
     ))



# Point Data --------------------------------------------------------------

(pts <- read_excel("Bird Survey Data/points.xlsx") %>%
   select(-dttm_created))
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

(d <- select(d, point_id, transect_name, PRIMARY_COM_NAME, survey_date, survey_mss,distance, observation_notes, data_entry_notes,
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

count(abc, PRIMARY_COM_NAME == "Black-billed Cuckoo")



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

#map image


# GRAPHS ------------------------------------------------------------------

# Bar graph, observation frequency per day

#2019
ggplot(data = nineteen) +
  geom_histogram(mapping = aes(x = survey_date), binwidth = 7, color = "black", fill = "#EE9A4D") +
  labs(x = "Survey Date", y = "Number of Observations", 
       title = "Number of Individual Bird Observations Per Week in 2019") 

#2018
ggplot(data = eighteen) +
  geom_histogram(mapping = aes(x = survey_date), binwidth = 7, color = "black", fill = "#EAC117")+
  labs(x = "Survey Date", y = "Number of Observations", 
       title = "Number of Individual Bird Observations Per Week in 2018")

  
ggplot(data = abc_c) +
  geom_histogram(mapping = aes(x = survey_date))

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
  geom_jitter(mapping = aes(x = PRIMARY_COM_NAME, y = point_id, color = survey_mss), alpha = .2) +
  labs(x = "Point ID", y = "Species (common name)", title = "Species Point Distribution, all years") +
  theme(
    axis.text.x = element_text(angle = 45, size = rel(.5), hjust = 1)
  )

# 2019

ggplot(data = nineteen) +
  geom_jitter(mapping = aes(x = PRIMARY_COM_NAME, y = point_id, color = point_id, 
                            shape = point_id), color = "#3EA99F", shape = 1, alpha = .3) +
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

#time

Histogram

# Scatter Plot species vs time

ggplot(data = abc) +
  geom_jitter(mapping = aes(x = survey_mss, y = PRIMARY_COM_NAME), 
              alpha = .2) +
  theme(
    axis.text.x = element_text(angle = 45, size = rel(1))
  )

# Line Graph, survey time

ggplot(data = d) +
  geom_line(mapping = aes(x = survey_mss, y = PRIMARY_COM_NAME))



# POSTER POSTER POSTER histogram, survey time POSTER POSTER POSTER

ggplot(data = d) +
  geom_vline(xintercept = 240, linetype = "dashed", size = 1, color = "red") +
  geom_histogram(mapping = aes(x = survey_mss),fill = "#92C7C7", 
                 color = "black", binwidth = 30, alpha = .5
                 ) +
  annotate(geom = "text", x = 250, y = 1000, hjust = 0, 
           label = "Cutoff time for surveys\n4 hours (240 minutes)\nafter sunrise") +
  labs(x = "Minutes after Sunrise", y = "Number of Observations", 
       title = "Most bird detections occur within 4 hours of sunrise") + 
  theme_classic()

ggplot(data = eighteen) +
  geom_vline(xintercept = 240, linetype = "dashed", size = 1, color = "red") +
  geom_histogram(mapping = aes(x = survey_mss),fill = "#4B0082", 
                 color = "black", binwidth = 30, alpha = .5
  ) +
  annotate(geom = "text", x = 250, y = 1000, hjust = 0) +
  labs(x = "Minutes after Sunrise", y = "Number of Observations", 
       title = "Time of observations 2018") + 
  theme_classic()

ggplot(data = nineteen) +
  geom_vline(xintercept = 240, linetype = "dashed", size = 1, color = "red") +
  geom_histogram(mapping = aes(x = survey_mss),fill = "#5E5A80", 
                 color = "black", binwidth = 30, alpha = .5
  ) +
  annotate(geom = "text", x = 250, y = 1000, hjust = 0) +
  labs(x = "Minutes after Sunrise", y = "Number of Observations", 
       title = "Time of Observations 2019") + 
  theme_classic()

# Histogram, bbc survey time

ggplot(data = bbc) +
  geom_histogram(mapping = aes(x = survey_mss), fill = "#92C7C7", color = "black", binwidth = 60)

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
  geom_point(mapping = aes(x = PRIMARY_COM_NAME, y = point_id))  #need to fix this somehow

# dates of all Black-billed Cuckoo observations
ggplot(data = bbc) +
  geom_point(mapping = aes(x = survey_date, y = point_id, color = transect_name, 
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
  geom_jitter(mapping = aes(x = point_id, y = survey_mss, color = observer_name),
              alpha = .5)

#mirror of time histogram of all birds
ggplot(data = bbc) +
  geom_histogram(mapping = aes(x = survey_mss),fill = "#008080", 
                 color = "black", binwidth = 50) +
  labs(x = "Minutes after Sunrise", y = "Number of Observations", 
       title = "Time Map of Black-billed Cuckoo Observations") + 
  theme_classic()


# BAR GRAPHS, environmental factors ---------------------------------------

#herbaceous
ggplot(data = bbc) +
  geom_bar(mapping = aes(x = herbaceous), color = "black", fill = "#FF7F50") +
  scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
  scale_y_continuous(breaks = seq(0, 6, 1), limits = c(0, 6)) +
  labs(x = "Percent of landscape that is Herbaceous", 
       y = "Black-billed Cuckoos observation count", title = "Herbaceous") +
  theme_classic() +
  theme(
    title = element_text(face = "bold")
  )

#shrub
ggplot(data = bbc) +
  geom_bar(mapping = aes(x = shrub), color = "black", fill = "#6AA121") +
  scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
  scale_y_continuous(breaks = seq(0, 6, 1), limits = c(0, 6)) +
  labs(x = "Percent of landscape that is Shrub", 
       y = "Black-billed Cuckoos observation count", title = "Shrub") +
  theme_classic() +
  theme(
    title = element_text(face = "bold")
  )

#forest
ggplot(data = bbc) +
  geom_bar(mapping = aes(x = forest), color = "black", fill = "#347235") +
  scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
  scale_y_continuous(breaks = seq(0, 6, 1), limits = c(0, 6)) +
  labs(x = "Percent of landscape that is Forest", 
       y = "Black-billed Cuckoos observation count", title = "Forest") +
  theme_classic() +
  theme(
    title = element_text(face = "bold")
  )

#river
ggplot(data = bbc) +
  geom_bar(mapping = aes(x = river), color = "black", fill = "#43BFC7") +
  scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
  scale_y_continuous(breaks = seq(0, 6, 1), limits = c(0, 6)) +
  labs(x = "Percent of landscape that is River", 
       y = "Black-billed Cuckoos observation count", title = "River") +
  theme_classic() +
  theme(
    title = element_text(face = "bold")
  )

#bare
ggplot(data = bbc) +
  geom_bar(mapping = aes(x = bare), color = "black", fill = "#AF9B60") +
  scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
  scale_y_continuous(breaks = seq(0, 6, 1), limits = c(0, 6)) +
  labs(x = "Percent of landscape that is Bare", 
       y = "Black-billed Cuckoos observation count", title = "Bare") +
  theme_classic() +
  theme(
    title = element_text(face = "bold")
  )

