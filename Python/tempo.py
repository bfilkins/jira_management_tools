

def tempo_query(start_date,end_date, auth_token):
    tempo = client.Tempo(
        auth_token = auth_token,
        base_url = "https://api.tempo.io/core/3")

    worklogs =pd.DataFrame(
        tempo.get_worklogs(
            dateFrom = start_date,
            dateTo = end_date
            )
        )

    issue = worklogs["issue"].apply(pd.Series)

    user = worklogs["author"].apply(pd.Series)

    attributes = worklogs["attributes"].apply(pd.Series)
    
    values = attributes["values"].apply(pd.Series)
    
    work_level = values[0].apply(pd.Series)
    work_level.columns = ["work_key", "work_level_value"]
    
    billable_type = values[1].apply(pd.Series)
    billable_type.columns = ["bill_key", "billable_value"]

    # need to trouble shoot bringing in attributes

    worklogs = pd.concat(
        [worklogs, 
        issue.reindex(worklogs.index), 
        user.reindex(worklogs.index),
        billable_type.reindex(worklogs.index),
        work_level.reindex(worklogs.index),
        #attributes.reindex(worklogs.index),
        values.reindex(worklogs.index)], 
        axis=1)
        
    return worklogs


