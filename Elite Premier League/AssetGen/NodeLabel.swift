//
//  NodeLabel.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 22/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit

class NodeLabel: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
       
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    //used to create text labels for nodes
    func labelGenerator(width: Double, height : Double, textColour : UIColor, bgColour : UIColor, size : Double, text : String){
        //creates a UI Label
        self.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(width), height: CGFloat(height))
        //sets the colour of the labels text
        self.textColor = textColour
        //alligns text to center of the label
        self.textAlignment = NSTextAlignment.center
        self.layer.backgroundColor = bgColour.cgColor
        //adds the text to the label
        self.text = text
        //sets the font and text size
        self.font = UIFont (name: "Premier League", size: CGFloat(size))
        //ensures text is adjusted
        //self.adjustsFontSizeToFitWidth = true
        self.adjustsFontForContentSizeCategory = true
    }
    
    //used to convert a uilable to a uiimage as its required to have no background on a plane node
    func convertLabelToImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    

}
