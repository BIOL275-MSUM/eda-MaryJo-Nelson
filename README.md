Identifying emerging patterns in yearly breeding bird surveys conducted
at the MSUM Regional Science Center
================
MaryJo Nelson
2021-03-26

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
table would show only the variables I wanted to look at (Wickham et al
2020). This gave me one clean, large table for all the data collected.
Finally, using this table and the base R filter function, I created
several smaller tables that only contained the information for each
individual year, transect, and specific species, such as the
Black-Billed Cuckoo (R Core Team 2020).

## Results

## Discussion

## References

Hadley Wickham, Romain François, Lionel Henry and Kirill Müller (2020).
dplyr: A Grammar of Data Manipulation. R package version 1.0.2.
<https://CRAN.R-project.org/package=dplyr>

Hadley Wickham and Jennifer Bryan (2019). readxl: Read Excel Files. R
package version 1.3.1. <https://CRAN.R-project.org/package=readxl>

R Core Team (2020). R: A language and environment for statistical
computing. R Foundation for Statistical Computing, Vienna, Austria. URL
<https://www.R-project.org/>.

RStudio Team (2021). RStudio: Integrated Development Environment for R.
RStudio, PBC, Boston, MA URL <http://www.rstudio.com/>.
