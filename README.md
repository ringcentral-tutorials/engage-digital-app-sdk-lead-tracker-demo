# Setup

## Environment variables



| Name                            | Mandatory | Default                   | Description                                                                                                                                                         |
|---------------------------------|-----------|---------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ED_DOMAIN_NAME                  | **YES**   | -                         | Name of your Engage Digital domain (e.g. if your URL is **domain-test**.digital.ringcentral.com, then your domain name is **domain-test**)                  |
| ED_HOSTNAME                     | NO        | `digital.ringcentral.com` | Hostname of your Engage Digital domain (e.g. if your URL is domain-test.**digital.ringcentral.com**, then your domain name is **digital.ringcentral.com**)  |
| ED_API_ACCESS_TOKEN             | **YES**   | -                         | Engage Digital API access token (:warning: **must** have the `Read identities` or the `Update identities` permission)                                               |
| ED_APP_SDK_CLIENT_ID            | **YES**   | -                         | ID of the application installed on Engage Digital                                                                                                                   |
| ED_APP_SDK_CLIENT_SECRET        | **YES**   | -                         | Secret of the application installed on Engage Digital                                                                                                               |
| LEAD_TRACKER_DATABASE_NAME      | **YES**   | -                         | Name of the postgresql database                                                                                                                                     |
| LEAD_TRACKER_DATABASE_USERNAME  | **YES**   | -                         | Username to connect to the postgresql database                                                                                                                      |
| LEAD_TRACKER_DATABASE_PASSWORD  | **YES**   | -                         | Password to connect to the postgresql database                                                                                                                      |


## Dynamic form configuration

Dynamic form can be configured thanks to the `config/form_configuration.yml` file, here's the file's expected structure:

```yaml
entities:
  stanford:               # Name of the entity
    channel_ids:          # List of ED channel ids
      - 'channel_id_1'
    config:
      - name: "GPA"       # Name of the field (which will be displayed as a label in the form)
        type: "input"     # Type of field
      - name: "Major"
        type: "select"
        options:          # Available options for the select
          - "Engineering"
          - "Economy"
      - name: "Background"
        type: "textarea"
      - name: "Scolarship"
        type: "checkbox"

  harvard:
    channel_ids:
      - ...
    config:
      - ...
```

Available types of element for the dynamic form are:
| Name        | Type of field saved in DB | Comment                                           |
|-------------|---------------------------|---------------------------------------------------|
| `input`     | String                    | -                                                 |
| `checkbox`  | Boolean                   | -                                                 |
| `select`    | String                    | Won't be displayed if the `options` list is empty |
| `textarea`  | String                    | -                                                 |

# Overview

## Interaction with Engage Digital



## Database architecture

### Lead

| Name               | Type     | Description                                                                   |
|--------------------|----------|-------------------------------------------------------------------------------|
| id                 | Integer  | Unique identifier                                                             |
| identity_group_id  | String   | Unique identifier for the identity group on Engage Digital                    |
| entity             | String   | Name of the entity (based on the configuration file)                          |
| firstname          | String   | -                                                                             |
| lastname           | String   | -                                                                             |
| email              | String   | -                                                                             |
| phone_number       | String   | -                                                                             |
| question           | String   | -                                                                             |
| comment_summary    | String   | -                                                                             |
| lead_type          | String   | Can be either `qualified_lead` or `email_only`                                |
| agent_id           | String   | ID of the agent creating the identity group                                   |
| intervention_id    | String   | ID of the intervention (if present) from which the identity group was created |
| thread_id          | String   | ID of the thread from which the identity group was created                    |
| data               | Hash     | JSON representation of the dynamic data filled by the custom form             |
| created_at         | DateTime | Date of the record creation                                                   |
| updated_at         | DateTime | Timestamp of the last update                                                  |
