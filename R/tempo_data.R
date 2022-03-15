
tempo_data <- py$tempo_query(start_date = start_date, end_date = end_date, auth_token = Sys.getenv("tempo_auth_token")) %>%
  select(
    startDate, displayName, key,
    work_level_value, billable_value,
    description,timeSpentSeconds,
    billableSeconds
  ) %>%
  mutate(
    hours_logged = timeSpentSeconds/3600,
    billed_hours_logged = billableSeconds/3600
  )


