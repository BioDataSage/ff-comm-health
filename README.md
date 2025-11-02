# The Patient Profile Cluster

## Goal

This project aims to cluster individuals based on how they move and see how that correlates with their satisfaction / serivces. Not all patients are the same. We used machine learning to find 3 'hidden' patient profiles based on how they move, not just their age. This lets us target care to who really needs it.

------------------------------------------------------------------------

## Steps taken

-   Step 1 : Preprocessing. The data is prepared for the clustering. Converting categorical columns to factors and recoding values in some categorical columns to numeric to enable the model learn.

-   Step 2 : Isolating the Movement variables We select the bio-mechanical variables from the dataset ; `Step.Frequency`, `Stride.Length`, `Joint.Angle`, `EMG.Activity`

    **Rationale**: These variables give us an overview of people's movements not who they are. This gives us an unbiased physical grouping

-   Step 3 : Normalizing the data. Before Clustering we must scale the data to level the playing field for all values.

## ML model

We ran a K-Means clustering model to identify hidden patterns within patients using their biomechanic information. 
Our model uncovered a fascinating truth, the most important factor in the mobility of patient isnt their stride length, joint angle or EMG Activity but solely how fast they walk.
With this insight we created 3 clear patient profiles; Slow walkers, Steady walkers and Fast walkers.


## Analysis

Based on these profiles we will now narrow down to analyse how each profile 