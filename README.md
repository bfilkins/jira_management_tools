# jira_management_tools

This repository is a series of tools to help with management level tasks. This workflow helps to query data from Jira and Tempo APIs and transform and merge to support with automation for utilization analysis.

The exec.R file controls the workflow and scripts are sourced from python and R for respective APIs.

Some of the things that I think are most interesting here is defining and calling python functions in R. Error trapping API calls with R's tryCatch functionality and writing out to tableau's .hyper file format so project managers or business analyst stakeholders can consume the data in a very clean way.
