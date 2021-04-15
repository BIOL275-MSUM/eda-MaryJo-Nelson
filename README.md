
<img src="https://www2.mnstate.edu/uploadedImages/Content/Marketing/logos/MSUM_Signature_Vert_Color.jpg" alt="MSUM logo" width="200" style="float:right"/>

# Identifying Emerging Patterns in Yearly Breeding Bird Surveys Conducted at the MSUM Regional Science Center

MaryJo Nelson, Dr. Chris Merkord

Biosciences Department, Minnesota State University Moorhead, 1104 7th
Avenue South, Moorhead, MN 56563 USA

<img src="Images/black-billed-cuckoo_flickr-1-adult.jpg" width="1000"/>

Black-billed Cuckoo

*Photo: Tom Murray/Flickr (CC BY NC 2.0)*

## Abstract

Long-term studies of the presence and distribution of species within an
ecosystem can provide an understanding of the health of that ecosystem
over time, thus aiding researchers in assessing the necessity of
conservation efforts for those species, and in determining the efficacy
of previously implemented conservation efforts. For the past three
years, students in the Geospatial Ecology Lab have been conducting
breeding bird surveys at the MSUM Regional Science Center, and my goal
is to conduct an exploratory data analysis to determine if any patterns
have begun to emerge by looking at broad population movement in space
and time, as well as patterns in behavior and habitat selection within
individual species. Specifically, I will look at the distribution of the
Black-billed Cuckoo and assess what environmental variables might affect
its habitat selection, as this pertains directly to research that I will
be conducting this summer. With only three years of data, it might be
too soon to make any significant assumptions about longitudinal changes
in populations, however I am hoping to get a good idea of the
distribution of various species with regard to location, habitat, and
the time of day/year they are most likely to be observed. Having this
information will provide the basis for asking more specific research
questions in the future, and beginning a broad analysis at this stage in
the project can make it easier to make comparisons to future data about
the state of the ecosystem at the Regional Science Center.

## Introduction

### Longitudinal Breeding Bird Surveys:

![](Images/Summer%20Bird%20Survey%20Map.png)

Map of survey points within Orange, Blue, Purple, and Yellow transects.

### Black-billed Cuckoos:

## Methods

### Data Acquisition

I am using data collected from longitudinal bird surveys conducted at
the MSUM Regional Science Center in 2018 and 2019 by the Geospatial
Ecology Lab in the Biosciences Department of MSUM. I exported the data
from a Microsoft Access database into Excel, and then read the Excel
sheets into RStudio using the (readxl) package (RStudio Team 2021,
Wickham et al 2019).

### Data Preparation

The data collected was spread amongst several tables, with the variables
I was hoping to compare all being in different locations. Therefore, the
next step I took was to join the desired tables using the left\_join
function in (dplyr). I then used the select function in (dplyr) so the
table would show only the variables I wanted to look at, including point
ID, species observed, survey date and time, observer, and landscape and
environmental factors (Wickham et al 2020). This gave me one large,
clean table for all the data collected. For the survey time, I used the
mutate function in (dplyr), the hour and minute functions in
(lubridate), as well as some basic math functions in base R to convert
the time that each survey was recorded into minutes passed since sunrise
(Wickham et al 2020; Grolemund 2011; R Core Team 2020). Finally, using
this table and the base R filter function, I created several smaller
tables that only contained information for each individual year,
transect, and specific species, such as the Black-Billed Cuckoo (R Core
Team 2020).

### Data Analysis

The first thing I did in my analysis of the data was to make a series of
graphs using many functions in (ggplot2) to compare various variables to
each other in order to determine if any patterns were beginning to
emerge (Wickham 2016). One of the things I wanted to look at was when
surveyors were most likely to observe birds, both with with regard to
time of day and time of year, so I created several histograms using
geom\_histogram in (ggplot2) to visualize the number of observances that
were occurring, regardless of species, at each time of day and year. I
did this for all years combines, broken down by year, and also filtered
for the Black-billed Cuckoo species. My second goal was to see if any
patterns could be seen with regard to the types of landscape variables
present where Black-billed Cuckoos had been observed. Prior to the very
first survey, students had looked at aerial imagery of each point to
estimate what percentage of the landscape in each area was herbaceous,
shrub, forest, river, and bare. I used their estimations and, using the
geom\_bar function in (ggplot2), I compared how many Black-billed Cuckoo
observations had occurred at points with varying percentages of each
landscape variable.

## Results

### When is the best time of summer to see breeding birds?

#### Number of Individual Bird Observations Per Week

Dates with most observations inconsistent from year to year

![](README_files/figure-gfm/histograms,%20date%20vs.%20observation%20count-1.png)<!-- -->

### When is the best time of day to see breeding birds?

![](README_files/figure-gfm/time%20of%20observations,%20all-1.png)<!-- -->

Time of observations ***is*** consistent from year to year.

![](README_files/figure-gfm/time%20filtered%20by%20year-1.png)<!-- -->

Black-billed Cuckoos appear to be observed later in the day.

![](README_files/figure-gfm/bbc%20time-1.png)<!-- -->

### What landscape variables correlate with where Black-billed Cuckoos are found?

![](README_files/figure-gfm/bbc%20landscape%20factors-1.png)<!-- -->

## Discussion

### Time of Summer:

### Time of Day:

### Landscape Correlates for Black-billed Cuckoo Observations:

## References

-   Grolemund, Garrett and Hadley Wickham (2011). Dates and Times Made
    Easy with lubridate. Journal of Statistical Software, 40(3), 1-25.
    URL <https://www.jstatsoft.org/v40/i03/.>

-   R Core Team (2020). R: A language and environment for statistical
    computing. R Foundation for Statistical Computing, Vienna, Austria.
    URL <https://www.R-project.org/>.

-   RStudio Team (2021). RStudio: Integrated Development Environment
    for R. RStudio, PBC, Boston, MA URL <http://www.rstudio.com/>.

<!-- -->

-   Wickham, Hadley. ggplot2: Elegant Graphics for Data Analysis.
    Springer-Verlag New York, 2016.

<!-- -->

-   Wickham, Hadley and Jennifer Bryan (2019). readxl: Read Excel Files.
    R package version 1.3.1. <https://CRAN.R-project.org/package=readxl>

<!-- -->

-   Wickham, Hadley, Romain François, Lionel Henry and Kirill Müller
    (2020). dplyr: A Grammar of Data Manipulation. R package version
    1.0.2. <https://CRAN.R-project.org/package=dplyr>

-   Wickham, Hadley (2021). tidyr: Tidy Messy Data. R package version
    1.1.3. <https://CRAN.R-project.org/package=tidyr>
