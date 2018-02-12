//
//  ImageRecognitionViewController.swift
//  Elite Premier League
//  This class uses a CNN mopdel to idetify a Pl teams cresta nd requests data from a server on the team
//  Created by JOHN KENNY on 28/01/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import Alamofire
import SwiftyJSON

class ImageRecognitionViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    //a view that houses the video feed
    @IBOutlet weak var videoFeedView: UIView!
    //capture video vars
    var captureSession = AVCaptureSession()
    //get camera output
    var output  = AVCapturePhotoOutput()
    //used for the voideo preview layer for images
    var preview = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the camera to feed images to the model
        camera()
    }

    //function an initialise the videoFeed from the iOS device and embedd input in the view
    func camera(){
        //sets up the camera session as photo as still images are used by the model
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        //sets the device media type to video no audio required
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        // set the input to the videoFeedView to embed the video feed to the view
        if let input = try? AVCaptureDeviceInput(device: device!){
            //try to add the input to avoid errors
            if (captureSession.canAddInput(input)){
                //add the input
                captureSession.addInput(input)
                //ceck if an output can be added
                if(captureSession.canAddOutput(output)){
                    //add the output
                    captureSession.addOutput(output)
                }
                //set the session to the preview layer
                preview.session = captureSession
                //sets the visoe to full view size
                preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
                //match the view
                preview.frame =  videoFeedView.bounds
                //display the video
                videoFeedView.layer.addSublayer(preview)
                //start the feed
                captureSession.startRunning()
            }
        }
        getImageFromCamera()
        
    }//end of camera set up
    
    //used to get the current iumage from the camera feed
    @objc func getImageFromCamera(){
        //settings for image capture
        let settings = AVCapturePhotoSettings()
        //take the first available format from the camera
        let pixType = settings.availablePreviewPhotoPixelFormatTypes.first!
        //set the width and height to match the model
        let format = [
            kCVPixelBufferPixelFormatTypeKey as String : pixType,
            kCVPixelBufferWidthKey as String : 250,
            kCVPixelBufferHeightKey as String : 250
        ]
        settings.previewPhotoFormat = format
        //capture image from camera calling the photoOutput method
        output.capturePhoto(with: settings, delegate: self)
    }
    
    //access the image
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        //gives error if cant get the image
        if let error = error{
            print ("error getting photo \(error)")
        }
        //get the image
        if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData){
            //send the image to the model to be predicted
            self.scanCrest(image: image)
        }
    }
    
    
    //uses the model to idenifiy a crest
    func scanCrest(image: UIImage){
        //get the image using the file path
        if let data = UIImagePNGRepresentation(image){
            let fileName = self.getDirectory().appendingPathComponent("crest.png")
            //store the image
            try? data.write(to: fileName)
            //feed the image into the model as input use its url
            //set up the model
            let model = try! VNCoreMLModel(for: crestIdeniferCNN().model)
            //run the model & get results
            let request = VNCoreMLRequest(model: model, completionHandler: results)
            let handler = VNImageRequestHandler(url: fileName)
            //only one request
            try! handler.perform([request])
        }
    }
    
    //a vision requestion event handler
    func results(request: VNRequest, error : Error?){
        //if cant get an output exit this fuction to avoid the app crashing
        guard let prediction = request.results as? [VNClassificationObservation] else{
            fatalError("could not get any output")
        }
        //used to hold the team the modle identifies
        var  team = "Man Utd"
        //the covidences of the model team match
        var confidence : VNConfidence = 0
        //loops thourgh the models results
        for classification in prediction {
            if classification.confidence > confidence {
                //sets the convudence var
                confidence = classification.confidence
                //sets the team var
                //team = classification.identifier
                print("prediction  \(classification.confidence) : team \(classification.identifier)")
            }
        }
        
        //if its found a match send a request to the server
        if (confidence > 0.1){
            print("i think its \(team) im \(confidence) sure!!")
            //requests the teams data from the server
            requestTeamData(teamName: team)
         
        //or else repeat this process
        }else{
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getImageFromCamera), userInfo: nil, repeats: false)
        }
    }
    
    //fucntion to request the data of the found team from the server
    func requestTeamData(teamName: String){
        let parameters: Parameters = ["name": teamName]
        print("get server request")
        let url = "http://192.168.0.157:8080/rest/getData/"
        //request to Django server ---  NB *******Django server Must Be started***********
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                let swiftyJsonVar = JSON(response.result.value!)
                //debugPrint(response)
                print(swiftyJsonVar["team"])
                //update the team using the current teams details
                GlobalVar.currentTeam  = Team(name : swiftyJsonVar["team"]["name"].rawString()!,code : Int(swiftyJsonVar["team"]["code" ].rawString()!)!,
                                      defHome   : Int(swiftyJsonVar["team"]["strength_defence_home" ].rawString()!)!,
                                      attHome   : Int(swiftyJsonVar["team"]["strength_attack_home"].rawString()!)!,
                                      home      : Int(swiftyJsonVar["team"]["strength_overall_home" ].rawString()!)!,
                                      defAway   : Int(swiftyJsonVar["team"]["strength_defence_away"].rawString()!)!,
                                      attAway   : Int(swiftyJsonVar["team"]["strength_attack_away" ].rawString()!)!,
                                      away      : Int(swiftyJsonVar["team"]["strength_overall_away" ].rawString()!)!)
                
                
                print(swiftyJsonVar)
                //creates a fiture object
                 let fixture = Fixture(
                    homeTeam    : swiftyJsonVar["fixture"]["homeTeam"].rawString()!,
                    awayTeam    : swiftyJsonVar["fixture"]["awayTeam"].rawString()!,
                    date        : swiftyJsonVar["fixture"]["date"].rawString()!,
                    homeGoals   : Int(swiftyJsonVar["fixture"]["homeGoals"].rawString()!)!,
                    awayGoals   : Int(swiftyJsonVar["fixture"]["awayGoals"].rawString()!)!)
                
                GlobalVar.currentTeam?.thisFixture = fixture
                print("players")
                //creates a list of players from the json
                let list: Array<JSON> = swiftyJsonVar["players"].arrayValue
                //loops through the list of players
                var x = [Player] ()
                for p in list{
                    //creates a player object
                    let named = Player(playerId      : Int(p["playerId"].rawString()!)!,
                                       team          : GlobalVar.currentTeam!,
                                       fName         : p["f_name"].rawString()!,
                                       lName         : p["l_name"].rawString()!,
                                       pos           : Int(p["pos"].rawString()!)!,
                                       goals         : Int(p["goals"].rawString()!)!,
                                       assits        : Int(p["assits"].rawString()!)!,
                                       saves         : Int(p["saves"].rawString()!)!,
                                       number        : Int(p["number"].rawString()!)!,
                                       cleanSheets   : Int(p["clean_sheets"].rawString()!)!,
                                       ownGoals      : Int(p["own_goals"].rawString()!)!,
                                       penoSaved     : Int(p["penalties_saved"].rawString()!)!,
                                       penoMissed    : Int(p["penalties_missed"].rawString()!)!,
                                       photoURL      : p["photo"].rawString()!,
                                       yellowCards   : Int(p["yellow_cards"].rawString()!)!,
                                       redCards      : Int(p["red_cards"].rawString()!)!)
                    print(named.returnDetails())
                    //adds each player to the teams list of players
                    x.append(named)
                    
                    //GlobalVar.currentTeam?.addPlayer(player: named)
                    print("\(GlobalVar.currentTeam?.players?.count)")

                }
                //sets the teams players
                GlobalVar.currentTeam?.thisPlayers = x
                self.callSegue(identifier: "teamScreen")
        }
    }
    
    //This method is called to change to the main menu screen
    func callSegue(identifier: String) {
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    //get the document location of a file using a url
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
