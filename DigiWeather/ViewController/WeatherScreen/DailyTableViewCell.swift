//
//  DailyTableViewCell.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/24/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import UIKit
import Kingfisher

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var highestTempLabel: UILabel!
    @IBOutlet weak var lowestTempLabel: UILabel!
    
    var item: Daily!{
        didSet{
            self.updateUI()
        }
    }
    
    //updateUI
    fileprivate func updateUI(){
        self.weekDayLabel.text = item.weekDay
        self.conditionImageView.kf.setImage(with: URL(string: item.iconUrl))
        self.highestTempLabel.text = item.highestTemp
        self.lowestTempLabel.text = item.lowestTemp
    }
    
}
