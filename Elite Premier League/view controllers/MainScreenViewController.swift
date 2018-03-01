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

class MainScreenViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    //sets the AR configuration
    let configuration = ARWorldTrackingConfiguration()
    private let model = CNN2()
    
    
    private var visionRequests = [VNRequest]()
    
    private var hitTestResult : ARHitTestResult!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self
        //runs the preset configuration in the scene to track the real world
        sceneView.session.run(configuration)
        
        loadTapGestureRecognizer()
        
    }
    
    //enable the tab
    private func loadTapGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer : UIGestureRecognizer){
        
        let sceneRecognizer = recognizer.view as! ARSCNView
        //checks id a ar element is been touched by the user
        let touchLoaction = self.sceneView.center
        
        guard let currentframe = sceneRecognizer.session.currentFrame else {
            print ("nothing in frame")
            return
        }
        
        let hitTestResults = sceneRecognizer.hitTest(touchLoaction, types: .featurePoint)
        
        if hitTestResults.isEmpty{
            print("nothing in hittest")
            return
        }
        
        guard let hitTestResult = hitTestResults.first else {
            print ("nothing in frame")
            return
        }
        
        self.hitTestResult = hitTestResult
        //image from current frame
        let pixelBufImage = currentframe.capturedImage
        
        analyiseImage(image: pixelBufImage)
        
    }
    
    //creates a vision request to analiyze the image
    private func analyiseImage(image : CVPixelBuffer){
        //converts the model to a vuison model
        let visionModel =  try! VNCoreMLModel(for: model.model)
        
        let request = VNCoreMLRequest(model: visionModel){ request, error
            in
            if error != nil {
                print ("error")
                return
            }
            
            guard let observ = request.results else {
                return
            }
            
            let ob = observ.first as! VNClassificationObservation
            
            print("\(ob.identifier) - Confidence: \(ob.confidence)")
            self.displayName(text : "Name \(ob.identifier) & confidence \(ob.confidence)")
            
        }
        
        request.imageCropAndScaleOption = .scaleFit
        visionRequests = [request]
        
        let imageReqHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .upMirrored, options: [:])
        DispatchQueue.global().async {
            try! imageReqHandler.perform(self.visionRequests)
        }
        
    }
    
    
    private func displayName(text : String){
        let node = createTextNode(text : text)
        
        node.position = SCNVector3(self.hitTestResult.worldTransform.columns.3.x,self.hitTestResult.worldTransform.columns.3.y, self.hitTestResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    private func createTextNode(text : String) -> SCNNode{
        let parent = SCNNode()
        //create a sselecter for the object
        let selectorNode = SCNNode(geometry :SCNSphere(radius: 0.01))
        selectorNode.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 1)
        
        let textNode = SCNText(string: text, extrusionDepth: 0)
        textNode.alignmentMode = kCAAlignmentCenter
        textNode.firstMaterial?.diffuse.contents = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 1)
        textNode.firstMaterial?.specular.contents = UIColor.white
        textNode.firstMaterial?.isDoubleSided = true
        
        textNode.font = UIFont(name: "Premier League", size: 0.10)
        
        let tNode = SCNNode(geometry: textNode)
        tNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        parent.addChildNode(selectorNode)
        parent.addChildNode(tNode)
        return parent
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
