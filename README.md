Identifying emerging patterns in yearly breeding bird surveys conducted
at the MSUM Regional Science Center
================
MaryJo Nelson
2021-03-11

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

\#\#\# cite some peer reviewed sources

## Methods

1.  load packages and import data from excel sheets
2.  join tables with common variable (point\_id) to be able to make
    comparisons - points - surveys - observations - observer - species
    1.  omit “bird sp.” and “NA” from common name variable
    2.  graphs to compare variables of interest
        -   point id vs. species
        -   species frequency
        -   frequency of birds sighted at each point
3.  Filter for year
    1.  graphs
        -   species frequency each year
        -   point id vs species each year
4.  Filter for black-billed cuckoo
    1.  count
    2.  graphs
        -   black billed cuckoo point distribution

## Analysis

## Results

### tidbits

-   create a folder for data
-   remember what we learned about different functions in R
-   write all steps taken down and record in readme
