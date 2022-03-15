# Exec Script
# Author: Brendan Filkins
# Description: Control script for querying Tempo/Jira data for reporting

# Set report Dates (move this somewhere else)
start_date <- "2022-1-1"
end_date <- "2023-1-1"

# Load Packages
source("R/packages.R")
source_python("Python/packages.py")

# Define Tempo query function and query Tempo API
source_python("Python/tempo.py")
source("R/tempo_data.R")

# Query All Jira Projects (do I need to do this everytime?)
source("R/jira.R")

# Join and write date
source("R/join_timesheet_detail.R")
source_python("Python/write_to_hyper.py")
