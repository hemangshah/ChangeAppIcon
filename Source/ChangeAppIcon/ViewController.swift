//
//  ViewController.swift
//  ChangeAppIcon
//
//  Created by Hemang on 5/8/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

private enum cityName:String {
    case london
    case mumbai
    case newyork
    case sydney
}

class ViewController: UIViewController {

    @IBOutlet weak var segmentCurrentCity: UISegmentedControl!
    @IBOutlet weak var imgViewCityIcon: UIImageView!
    
    var arraySegmentValues = Array<String>()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getAllTitles()
        setCurrentSelection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: IBAction
    @IBAction func actionCityChange(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let selectedCity = getCityNameForIndex(index: selectedIndex)
        let icon = iconNameForSelection(city: selectedCity)
        let plistIconKeyName = plistIconKeyForSelection(city: selectedCity)
        
        setCityIconWithName(iconName: icon)
        
        if(selectedIndex > 0) {
            setAppIconWithName(appIcon: plistIconKeyName)
        } else {
            // 0 index = London
            //This will set the primary icon.
            UIApplication.shared.setAlternateIconName(nil)
        }
    }
    
    //MARK: Helpers
    private func getAllTitles() -> Void {
        for index in 0..<segmentCurrentCity.numberOfSegments {
            arraySegmentValues.append(segmentCurrentCity.titleForSegment(at: index)!)
        }
    }
    
    private func setCurrentSelection() -> Void {
        let currentAppIconName = UIApplication.shared.alternateIconName ?? ""
        segmentCurrentCity.selectedSegmentIndex = getSegmentIndexFromPlistIconKey(iconName: currentAppIconName)
        let selectedCity = getCityNameForIndex(index: segmentCurrentCity.selectedSegmentIndex)
        let icon = iconNameForSelection(city: selectedCity)
        setCityIconWithName(iconName: icon)
    }
    
    private func setCityIconWithName(iconName:String) -> Void {
        imgViewCityIcon.image = getImageForImageName(imageName: iconName)
    }
    
    private func setAppIconWithName(appIcon:String) -> Void {
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(appIcon) { error in
                if let error = error {
                    print("Error while changing the app icon: \(error)")
                }
            }
        }
    }
    
    private func getCityNameForIndex(index:Int) -> cityName {
        switch index {
        case 1:
            return .mumbai
        case 2:
            return .newyork
        case 3:
            return .sydney
        default:
            return .london
        }
    }
    
    private func getImageForImageName(imageName:String) -> UIImage {
        return UIImage.init(named: imageName)!
    }
    
    //This method is use to get app icon for UIImageView.
    private func iconNameForSelection(city:cityName) -> String {
        return "ic_".appending(city.rawValue)
    }
    
    //This method is used to get plist's app icon name.
    private func plistIconKeyForSelection(city:cityName) -> String {
        return "city_".appending(city.rawValue)
    }
    
    //This function is used to get the segment index for the particular app icon key in plist.
    private func getSegmentIndexFromPlistIconKey(iconName:String) -> Int {
        let onlyCity = iconName.components(separatedBy: "_").last!
        guard !onlyCity.isEmpty else {
            return 0
        }
        
        let upperCaseCity = onlyCity.capitalized
        guard arraySegmentValues.contains(upperCaseCity) else {
            return 0
        }
        return arraySegmentValues.index(of: upperCaseCity)!
    }
}
