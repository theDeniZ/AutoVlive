# AutoVlive

This project was created to automate vlive experience in posting likes to a video/live.

The project focus was set to write an app to access vlive video information and post likes. The only required features 
for that are:
- User Login screen
- Video List
- Video info screen

As a convenience feature, history of all videos and posted likes was also implemented.

As poc, was also implemented multi user access as well as given some control over the likes posting process.

Thus, the theoretical maximum of likes / user allowed on vlive can be reached.  

## Architecture

This project implements UI of the app as well as the management of users, videos and likes-posting.

The Api client to vlive is developed separately. 

The login process of vlive was not implemented, as there is no documentation provided. Instead, the user is 
authenticated with cookies only. Thanks to the cookies management of vlive, they are more or less persistant.

## Data Backup

In order to save and restore user data and likes history, a private server can be reached with some simple 
authorization. UI for error handling and user feedback was not developed.
