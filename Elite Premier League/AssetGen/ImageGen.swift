//
//  ImageGen.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 21/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit

class ImageGen: UIImage {
    // any additional properties can go here
    
    override init() {
        let image = UIImage(named: "image-name")!
        super.init(cgImage: image.cgImage!, scale: UIScreen.main.scale, orientation: .up)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init(imageLiteralResourceName name: String) {
        fatalError("init(imageLiteralResourceName:) has not been implemented")
    }
    
    
    //used to convert a uilable to a uiimage as its required to have no background on a plane node
   /* func convertLabelToImage(label : UILabel) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        label.drawHierarchy(in: label.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image!
    }
    
    
    
    func convertViewToImage(view : UIView){
        //converts the view to a UIIMage
        UIGraphicsBeginImageContext(view.frame.size)
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //returns a ui image created from the view
        self = image!
    }*/

}
