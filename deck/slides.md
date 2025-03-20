---
subtitle: Case
date: March 21st, 2025
title: GymCPH Access Data
author:
  - Magnus Berg Sletfjerding
theme: metropolis
aspectratio: 169
toc: true
slide-level: 2
---

# The Idea
## Find data for a CPH based gym and analyse it 💸

::: columns

:::: column

### GymCPH Intro
1. GymCPH is a medium sized gym in the Greater Copenhagen Area
2. They have asked us to find recommendations for how to improve their offering
3. Their main goal is customer satisfaction and their current revenue allows them to operate comfortably.
4. Owned by a non-profit they do not seek profits directly but would like to retain members. 

::::

:::: column

### Data available
1. Data from door access system
2. Membership database dump (anonymised) 🇪🇺
3. All public data

::::

:::


# The Solution 

## Architecture 

```{=latex}
\includegraphics[width=\textwidth]{/Users/mags/Code/club-data-postgres/deck/gfx/architecture.png}
```

## Data Model
```{=latex}
\includegraphics[width=\textwidth]{/Users/mags/Code/club-data-postgres/deck/gfx/datamodel.png}
```



# Experiment overview 👨‍✈️
## Snowflake ❄️

::: columns

:::: column
### Actions
1. First I uploaded the Data into Snowflake, and began running SQL scripts on it.
2. However, once I tried to use the DBT Labs connection I ran into trouble. ➡️
3. At this point I was rather pressed on time, so I said _bye Snowflake_ and swapped to my trusty postgres 🐘
::::

:::: column
### Blocker
```{=latex}
\includegraphics[width=\textwidth]{/Users/mags/Code/club-data-postgres/deck/gfx/dbt-nay.png}
```

::::

:::

## Postgres 🐘

::: columns

:::: column
1. Runs locally
2. No login required
3. No quarantine time required to pull data
::::

:::: column

::::

:::


# Summary 
## Feature list I did not have time to implement 
1. Add weather data to check correlation over time 
2. Segment by age and find if there are some times that are more/less popular with age.


## What I would look into for scalability
- Snowpipe setup for streaming data into it 
- Airbyte type ELT job 
- Connecting to internet to be able to process larger datasets
- Figure out how to load HDF4 files from MODIS to do Geo Based things 

## Questions?