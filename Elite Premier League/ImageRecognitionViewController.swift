//
//  ImageRecognitionViewController.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 28/01/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit

import AVFoundation

import Vision

class ImageRecognitionViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    //a view that houses the video feed
    @IBOutlet weak var videoFeedView: UIView!
    
    //capture video vars
    var captureSession = AVCaptureSession()
    //get camera output
    var output  = AVCapturePhotoOutput()
    
    var preview = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //camera()
        camera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        //capture image from camera
        output.capturePhoto(with: settings, delegate: self)
        
        //use model to identify the image
        
        //get results and process them
    }
    
    //access the image
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
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
            let model = try! VNCoreMLModel(for: crestIdenifer3().model)
            let request = VNCoreMLRequest(model: model, completionHandler: results)
            let handler = VNImageRequestHandler(url: fileName)
            //only one request
            try! handler.perform([request])
        }
        
        
        
        
        
        //run the model
        
        //get results
    }
    
    
    func results(request: VNRequest, error : Error?){
        guard let prediction = request.results as? [VNClassificationObservation] else{
            fatalError("could not get any output")
        }
        
        var  team = ""
       // var conFide
        
        var confidence : VNConfidence = 0
        
        for classification in prediction {
            if classification.confidence > confidence {
                confidence = classification.confidence
                team = classification.identifier
                print("here working \(classification.confidence)")
            }
        }
        
        //if its found a match send a request to the server
        if (confidence > 0.90){
            print("i think its \(team) im \(confidence) sure!!")
         
        //or else repeat this process
        }else{
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getImageFromCamera), userInfo: nil, repeats: false)
        }
        
        
        
    }
    
    
    //get the document location of a file using a url
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

}
