//
//  StatsView.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 08/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit

class StatsView: UIView {
    
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statLabel: UILabel!
    
     override init (frame : CGRect){
     super.init(frame: frame)
     commonInit()
     }
     
     required init?(coder aDecoder: NSCoder) {
     super.init(coder : aDecoder)
     }
     
     private func commonInit(){
     Bundle.main.loadNibNamed("StatsView", owner: self, options: nil)
     addSubview(view)
     view.frame = self.bounds
     view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
     
     }
 

}
