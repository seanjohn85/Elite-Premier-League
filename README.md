# Elite-Premier-League
Front end applciation with core ml cnn model. This is an ios application that identifies EPL teams crest using a CNNs and diplaying the team name in a ar.
This application also connects to the rest api server https://github.com/seanjohn85/Premier-League/tree/Downloaded-Images/Server%20APP and displays the teams stats, players and makes predictions on the teams next game

Finally this application includes an AR mini game where pogba in placed in ar and the user has 10 seconds to find the model and touch it to increase their score.

## Elite-Premier-League

In order to set up the server please follow the server set up instructions on https://github.com/seanjohn85/Premier-League/tree/Downloaded-Images.
Once the server is running the static let serverAddress = "http://192.168.0.157:8080/" in GlobalVar will need to be changed to reflect the ip and port the server is running on.

###iOS set up 

I have includes the pods used in this repo as there have been changes in Swift4 and some of the pods are no longer working when downloaded from coccapods.

A Mac and an iOS device with AR capabilities is required to run this application

1. Open the workspace file in Xcode 
2. Click Elite Premier League and sign in with an ios developer profile. (see https://developer.apple.com on how to set up a developer account)
3. Plug in the iOS device and hit the run button and the app should oinstall on the device. 
4. each screen as a walkthrough guide to explain how to use the app.

####iOS

This application has over 60% test coverage in unit tests and the app can be ran in test mode to run the unit tests.

