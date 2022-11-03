# readme simplifying and updating this
follow all the steps from [this website](https://ithoughthecamewithyou.com/post/export-google-fit-daily-steps-to-a-google-sheet)

we can get any other data from google fit if we want. [The list here](https://developers.google.com/fit/rest/v1/reference/users/dataSources/list?apix_params=%7B%22userId%22%3A%22me%22%7D#auth)

the real file is a .gs file. But I've convert it to .js for better readability (as I've didn't find a .gs extension for vs code)


my cloud project link : https://console.cloud.google.com/apis/credentials/oauthclient/710666560092-6notetaf2opfsq2hefqjgl5hoj7sgfsi.apps.googleusercontent.com?project=metacare01


# si marche, virer toutes les apps sur mon tel et les permissions google 



# trouver équivalent pour heartrate :

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


# les jours se mettent, mais pas l'heart rate