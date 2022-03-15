# create time log data with jira detail ####

timesheet_detail <- tempo_data %>%
  inner_join(tickets, by = c("key" = "key"))

timesheet_detail <- r_to_py(timesheet_detail)  
