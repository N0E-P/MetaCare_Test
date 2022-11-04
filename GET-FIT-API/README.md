follow all the steps from [this website](https://ithoughthecamewithyou.com/post/export-google-fit-daily-steps-to-a-google-sheet)

we can get any other data from google fit if we want. [The list here](https://developers.google.com/fit/rest/v1/reference/users/dataSources/list?apix_params=%7B%22userId%22%3A%22me%22%7D#auth)

the real file is a .gs file. But I've convert it to .js for better readability (as I've didn't find a .gs extension for vs code)

[use spreadsheets as database](https://www.youtube.com/watch?v=K6Vcfm7TA5U)

Only work for one user (or have to do the OAuth) / test only

# sources :
première version du code
https://github.com/abfo/google-fit-to-sheets/blob/07bc7723676e36a3a017911a5c830ae9a452a65c/Code.gs

dataSourceId :
https://developers.google.com/fit/rest/v1/reference

dataTypes :
https://developers.google.com/fit/datatypes#using_data_types_with_the_rest_api

my cloud project link : https://console.cloud.google.com/apis/credentials/oauthclient/710666560092-6notetaf2opfsq2hefqjgl5hoj7sgfsi.apps.googleusercontent.com?project=metacare01


# comment ajouter d'autres valeurs à prendre ?