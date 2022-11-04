# readme simplifying and updating this



# les jours se mettent, mais pas l'heart rate
quand il n'y a pas de sourceId
https://stackoverflow.com/questions/64802370/how-to-get-weekly-google-fit-rest-api-data


# accéder au résumé journalier. pour avoir qu'une seule valeur

https://stackoverflow.com/questions/46425694/how-to-get-heart-rate-values-from-google-fit-history


# quand il y a sourceID
"dataSourceId": "derived:com.google.heart_rate.bpm:com.google.android.gms:heart_rate_bpm"

Donne : Exception: Request failed for https://www.googleapis.com returned code 403. Truncated server response: { "error": { "code": 403, "message": "datasource not found or not readable: derived:com.google.heart_rate.bpm:com.google.android.gms:hear... (use muteHttpExceptions option to examine full response)

{
"dataTypeName": "com.google.step_count.delta",
"dataSourceId": "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
},
{
"dataTypeName": "com.google.weight.summary",
"dataSourceId": "derived:com.google.weight:com.google.android.gms:merge_weight"
},
{
"dataTypeName": "com.google.distance.delta",
"dataSourceId": "derived:com.google.distance.delta:com.google.android.gms:merge_distance_delta"
}

:com.google.android.gms:heart_rate_bpm



# finir tuto
https://ithoughthecamewithyou.com/post/export-google-fit-daily-steps-to-a-google-sheet




# plusieurs valeurs d'heartrate pendant la journée