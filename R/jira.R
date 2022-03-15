

# Save credentials to pass them only one time
save_jira_credentials(
  domain = Sys.getenv("jira_domain"),
  username = Sys.getenv("jira_user"),
  password = Sys.getenv("jira_password")
)

fields <- supported_jql_fields() %>% 
  tibble()

# Get full list of projects in domain
projects_list <- get_jira_projects() %>% 
  select(key, name)


# Select Fields (need to figure out how to pull current sprint for each ticket, defaults to first)
fields_selected <- c("assignee", "summary",
                     "status", "created", "parent", #"description",  
                     "issuetype", "updated", "customfield_10010", #<- this custom attribute is the epic
                     "customfield_10008","customfield_10033")

# Select Projects (replace to reference the projects above)
projects_selected <- projects_list %>% select(project = key) 

# Project query function
query_jira_project <- function(project_key) {
  tryCatch(
  get_jira_issues(
    jql_query =  paste0('project = ','"', projects_list %>% filter(key == project_key) %>% pull(name),'"'), 
    fields = fields_selected) %>%
    mutate_all(as.character) %>%
    mutate(
      created = as.Date(created),
      updated = as.Date(updated)
      ),
  error = function(x){NA}) # I actually don't 100% know what I'm doing here should x be project_key?
}

tickets.0 <- projects_selected %>%
  mutate(data = map(project,query_jira_project)) %>%
  unnest(data)

# Transform logic to create Epic names across task types ####

epic_names <- tickets.0 %>%
  group_by(key,summary) %>%
  summarise() %>%
  select(key, epic_name = summary) %>%
  ungroup()

parent_epic_names <- tickets.0 %>%
  group_by(key, parent_key) %>%
  summarise() %>%
  ungroup() %>%
  inner_join(
    tickets.0 %>%
      group_by(key, customfield_10008) %>%
      summarise() %>%
      ungroup(),
    by = c("parent_key" = "key")) %>%
  inner_join(epic_names, by = c("customfield_10008" = "key")) %>%
  select(key, parent_epic_name = epic_name)


# Join Epic name lookups and create epic field ####

tickets <- tickets.0 %>%
  left_join(epic_names, by = c("customfield_10008" = "key")) %>%
  left_join(parent_epic_names, by = c("key" = "key")) %>%
  mutate(epic = if_else(is.na(epic_name), parent_epic_name, epic_name)) %>%
  select(project, id,key, summary, status_name, parent_key, customfield_10033, epic, assignee_displayname)
  
