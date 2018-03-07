//
//  AnimateViewController.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 02/03/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import BWWalkthrough

class AnimateViewController: UIViewController, BWWalkthroughPage {
    
    //ui elements
    @IBOutlet weak var iamge: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var subText: UILabel!
    
    //function to animate the
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
        var tr = CATransform3DIdentity
        tr.m34 = -1/500.0
        //text animate
        titleLab?.layer.transform = CATransform3DRotate(tr, CGFloat(Double.pi) * (1.0 - offset), 1, 1, 1)
        subText?.layer.transform = CATransform3DRotate(tr, CGFloat(Double.pi) * (1.0 - offset), 1, 1, 1)
        var tmpOffset = offset
        if(tmpOffset > 1.0){
            tmpOffset = 1.0 + (1.0 - tmpOffset)
        }
        //image animate
        iamge?.layer.transform = CATransform3DTranslate(tr, 0 , (1.0 - tmpOffset) * 200, 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
