//
//  PageViewController.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/23/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import UIKit
import RealmSwift

// PageViewControllerDelegate
protocol PageViewControllerDelegate: class {
    func pagesChanged(total: Int, current: Int)
}

class PageViewController: UIPageViewController {
    
    weak var pvcDelegate: PageViewControllerDelegate?
    
    fileprivate var displayIndex: Int = 0
    fileprivate var pages: [WeatherViewController] = [WeatherViewController](){
        didSet{
            pvcDelegate?.pagesChanged(total: pages.count, current: displayIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let weatherViewController = (self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController)!
        pages.append(weatherViewController)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let locationIds = BaseModule.shared.realm.objects(LocationRealm.self).value(forKey: "id") as! [String]
        for page in pages {
            if(!locationIds.contains(page.id) && !page.id.isEmpty){
                pages.remove(at: pages.index(of: page)!)
            }
        }
        
        let pageIds = pages.map { $0.id }
        for locationId in locationIds {
            if(!pageIds.contains(locationId)){
                let weatherViewController = (self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController)!
                weatherViewController.id = locationId
                pages.append(weatherViewController)
            }
        }
        
        displayIndex = 0
        if(BaseModule.shared.getLocationIdToDisplay() != ""){
            if let i = pages.index(where: {$0.id == BaseModule.shared.getLocationIdToDisplay()}){
                displayIndex = i
            }
        }
        
        setViewControllers([pages[displayIndex]], direction: .forward, animated: false, completion: nil)
        pvcDelegate?.pagesChanged(total: pages.count, current: displayIndex)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! WeatherViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! WeatherViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard pages.count != nextIndex else {
            return nil
        }
        
        guard pages.count > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension PageViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            if let current = pageViewController.viewControllers?[0]{
                if let currentIndex = pages.index(of: current as! WeatherViewController){
                    BaseModule.shared.setLocationIdToDisplay(displayId: pages[currentIndex].id)
                    pvcDelegate?.pagesChanged(total: pages.count, current: currentIndex)
                }
            }
        }
    }
}
