//
//  LeagueTableRow.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 10/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//


//this is used to create a view object to repesent each row of the league Tabel
import UIKit

class LeagueTableRow: UIView {

    
    @IBOutlet var view: UIView!
    
    //ui labels to be changed to repersent the table
    
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var dotLabel: UILabel!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var playedLabel: UILabel!
    
    @IBOutlet weak var wonLabel: UILabel!
    
    @IBOutlet weak var drawnLabel: UILabel!
    
    @IBOutlet weak var lossLabel: UILabel!
    
    @IBOutlet weak var gdLabel: UILabel!
    
    @IBOutlet weak var ptsLabel: UILabel!
    
    
    override init (frame : CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("LeagueTableRow", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
    }

}
