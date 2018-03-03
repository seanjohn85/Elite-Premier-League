//
//  MainScreenViewController.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 14/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import Vision
import VideoToolbox
import BWWalkthrough

class MainScreenViewController: UIViewController, ARSCNViewDelegate, BWWalkthroughViewControllerDelegate {
    
    //displays las checked image
    @IBOutlet weak var imageView: UIImageView!
    
    //lables
    @IBOutlet weak var infoBar: UILabel!
    @IBOutlet weak var team1: UILabel!
    @IBOutlet weak var team2: UILabel!
    @IBOutlet weak var team3: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    //sets the AR configuration
    let configuration = ARWorldTrackingConfiguration()
    //uswd to hold vision request
    private var visionRequests = [VNRequest]()
    //use dto hold toucjhed screen location to place elements in ar
    private var hitTestResult : ARHitTestResult!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.transform = imageView.transform.rotated(by: CGFloat(Double.pi / 2))
        // Set the view's delegate
        sceneView.delegate = self
        //runs the preset configuration in the scene to track the real world
        sceneView.session.run(configuration)
        loadTapGestureRecognizer()
    }
    
    //enable the tab gestures
    private func loadTapGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //used to handle tap gesture feeding images into core ml mode using vision requests
    @objc func tapped(recognizer : UIGestureRecognizer){
        let sceneRecognizer = recognizer.view as! ARSCNView
        //checks id a ar element is been touched by the user
        let touchLoaction = self.sceneView.center
        //if the current ar fram is empty exit this finction -- this should never be executed
        guard let currentframe = sceneRecognizer.session.currentFrame else {
            print ("nothing in frame")
            return
        }
        //used to get where the screen is touced in ar space
        let hitTestResults = sceneRecognizer.hitTest(touchLoaction, types: .featurePoint)
        
        //if there is nothing loaded in the hit test
        if hitTestResults.isEmpty{
            print("nothing in hittest")
            infoBar.text = "Nothing in frame. Please try again"
            return
        }
        
        guard let hitTestResult = hitTestResults.first else {
            print ("nothing in frame")
            return
        }
        
        self.hitTestResult = hitTestResult
        //image from current frame
        let pixelBufImage = currentframe.capturedImage
        //use model to exaine the results
        analyiseImage(image: pixelBufImage)
        
    }
    
  
    //creates a vision request to analiyze the image
    private func analyiseImage(image : CVPixelBuffer){
        //converts the model to a vuison model
        let visionModel =  try! VNCoreMLModel(for: GlobalVar.model.model)
        //sets up a vision request using the cnn model qeued in an async thread
        let request = VNCoreMLRequest(model: visionModel){ request, error
            in
            //if there is any issue with the model exit
            if error != nil {
                print ("error")
                return
            }
            //if there are no results return
            guard let observ = request.results else {
                print ("no results")
                return
            }
            
            //we need to return to the main tread to set a ui object
            DispatchQueue.main.async {
                //set the image view with the image currently been analyised
                self.imageView.image = UIImage(pixelBuffer: image)
                //set the image view with the image currently been analyised
                self.infoBar.text = "Current Top 3 Predictions"
            }
            //loop through the top 3 results
            for i in 0...2{
                //get the observer element of i
                let ob = observ[i] as! VNClassificationObservation
                //polulate the labels
                self.populateLabels(name: "Name \(ob.identifier) & confidence \(Int(ob.confidence*100))%", pos : i)
            }
        }
        //rescals the image
        request.imageCropAndScaleOption = .scaleFit
        visionRequests = [request]
        //sets the image in the request
        let imageReqHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .upMirrored, options: [:])
        //runs the async thread vith the vison request
         DispatchQueue.global().async {
            try! imageReqHandler.perform(self.visionRequests)
         }
    }
    
    //crestes the 3d nodes
    private func displayName(text : String){
        let node = createTextNode(text : text)
        //positions the text the same loaction as the scaned image
        node.position = SCNVector3(self.hitTestResult.worldTransform.columns.3.x,self.hitTestResult.worldTransform.columns.3.y, self.hitTestResult.worldTransform.columns.3.z)
        //adds the node to the scene
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    //team labels are set here
    private func populateLabels(name: String, pos : Int){
        //the first team is set here
        if pos == 0 {
            //displays an ar node above the element with the most likely prediction
            self.displayName(text : name)
            //we need to return to the main tread to set a ui object
            DispatchQueue.main.async {
                self.team1.text = "1. \(name)"
            }
        }else if pos == 1 {
            //we need to return to the main tread to set a ui object
            DispatchQueue.main.async {
                self.team2.text = "2. \(name)"
            }
        }else if pos == 2 {
            //we need to return to the main tread to set a ui object
            DispatchQueue.main.async {
                self.team3.text = "3. \(name)"
            }
        }
    }
    
    //creates the text node
    private func createTextNode(text : String) -> SCNNode{
        let parent = SCNNode()
        //create a sselecter for the object
        let selectorNode = SCNNode(geometry :SCNSphere(radius: 0.01))
        selectorNode.geometry?.firstMaterial?.diffuse.contents = GlobalVar.pink
        //addts the text of what crest was using a text node
        let textNode = SCNText(string: text, extrusionDepth: 0)
        textNode.alignmentMode = kCAAlignmentCenter
        //sets the syles of the text
        textNode.firstMaterial?.diffuse.contents = GlobalVar.pink
        textNode.firstMaterial?.specular.contents = UIColor.white
        textNode.firstMaterial?.isDoubleSided = true
        textNode.font = UIFont(name: "Premier League", size: 0.10)
        //adds the text to a node
        let tNode = SCNNode(geometry: textNode)
        tNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        //adds the child nodes to the parent
        parent.addChildNode(selectorNode)
        parent.addChildNode(tNode)
        return parent
    }
    
    
    @IBAction func helpBtn(_ sender: Any) {
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "ConfidenceWalkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "ConfidenceWalkthrough") as! BWWalkthroughViewController
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController: stb.instantiateViewController(withIdentifier: "con1"))
        walkthrough.add(viewController: stb.instantiateViewController(withIdentifier: "con2"))
        walkthrough.add(viewController: stb.instantiateViewController(withIdentifier: "con3"))
        walkthrough.add(viewController: stb.instantiateViewController(withIdentifier: "con4"))
        self.present(walkthrough, animated: true, completion: nil)
        
    }
    
    //close the walktrhough
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


//https://github.com/hollance/CoreMLHelpers/blob/master/CoreMLHelpers/UIImage%2BCVPixelBuffer.swift

extension UIImage {
    /**
     Creates a new UIImage from a CVPixelBuffer.
     NOTE: This only works for RGB pixel buffers, not for grayscale.
     */
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, nil, &cgImage)
        
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
}
