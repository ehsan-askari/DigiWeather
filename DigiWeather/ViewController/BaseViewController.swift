//
//  BaseViewController.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/22/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var wuLogoImageView: UIImageView!
    @IBOutlet weak var pageControl: LocationPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listButton.setFAIcon(icon: .FAListUl, iconSize: 25, forState: .normal)
        wuLogoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.wuLogoImageViewTapped(_:))))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // wuLogoImageViewTapped
    @objc func wuLogoImageViewTapped(_ sender: UITapGestureRecognizer){
        UIApplication.shared.openURL(URL(string: "https://www.wunderground.com/")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? PageViewController {
            destinationViewController.pvcDelegate = self
        }
    }
}

// MARK: - PageViewControllerDelegate
extension BaseViewController: PageViewControllerDelegate{
    func pagesChanged(total: Int, current: Int) {
        pageControl.currentPage = current
        pageControl.numberOfPages = total
    }
}



