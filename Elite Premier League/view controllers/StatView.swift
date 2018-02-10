//
//  TestView.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 07/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit

class TestView: UIView {
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet var view: TestView!
  

    
    override init (frame : CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("TestView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
}
