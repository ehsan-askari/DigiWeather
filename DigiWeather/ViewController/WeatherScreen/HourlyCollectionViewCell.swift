//
//  HourlyCollectionViewCell.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/24/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import UIKit
import Kingfisher

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var item: Hourly!{
        didSet{
            self.updateUI()
        }
    }
    
    // updateUI
    fileprivate func updateUI(){
        self.hourLabel.text = item.hour
        self.conditionImageView.kf.setImage(with: URL(string: item.iconUrl))
        self.tempLabel.text = item.temp
    }
}
