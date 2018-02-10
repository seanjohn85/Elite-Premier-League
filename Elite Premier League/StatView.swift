//
//  StatView.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 08/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit

class StatView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statLabel: UILabel!
    
    @IBOutlet var view: UIView!
    
    override init (frame : CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("StatView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }

}
