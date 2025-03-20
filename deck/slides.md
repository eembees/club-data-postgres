---
subtitle: LEAP - Case
date: March 21st, 2025
title: Animal-Go
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







# Captain's log 👨‍✈️
## Snowflake ❄️

::: columns

:::: column
### Actions
1. First I uploaded the Data into Snowflake, and began running SQL scripts on it.
2. However, once I tried to use the DBT Labs connection I ran into trouble.
3. At this point I was rather pressed on time, so I said _bye Snowflake_ and swapped to my trusty postgres 🐘
::::

:::: column

```{=latex}
\includegraphics[width=\textwidth]{/Users/mags/Code/club-data-postgres/deck/gfx/dbt-nay.png}
```

::::

:::

## Postgres 🐘

::: columns

:::: column

::::

:::: column

::::

:::




# Summary 

## WHat I would look into for scalability
- Snowpipe setup 
- Airbyte type ELT job 
- Connecting to internet to be able to process larger datasets
- Figure out how to load HDF4 files from MODIS to do Geo Based things 