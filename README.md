# Crash-Stats-Vic-Data

Analyzing Victorian Crash Data

August 2023

by Andre Medina

# Report

There is a [power point presentation](/presentation/When_Do_We_Need_Emergency_Services.pptx) which covers the findings and outlines the general investigation process. For the final conclusions of the data analysis, please view this presentation. You will find a general script in the notes section.

# Reproducing Results

To reproduce the graphs and models, please view the code in the [production_code folder](/production_code/). Follow the numeric order of the files from inital experimintation to producing the final model. In each file, you should find a header explain the contents 

# Data, Graphs and Documentation

Are all stored in the [data folder](/data/). All stages of data cleaning are stored there, from raw data, to cleaned data, to the final graphs.


# Other code

## [constants.py](/production_code/constants.py)

This file holds any key constants used through the code, including the dates of the train/ test split and file directories for most data files and graphs locations

## [sandbox code](/sandbox/)

This is where experiments that didnt make it into the final production code went. Including some other statistical models and a basic experiment with a nueral network model. The code may lack comments and be non-functional.