//
//  ViewController.swift
//  WeatherUsingJSONAPI
//
//  Created by Tauseef Kamal on 1/23/17.
//  Copyright © 2017 tauk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblCurrentTemp: UILabel!
    
    @IBOutlet weak var lblMaxTemp: UILabel!
    
    @IBOutlet weak var lblMinTemp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //get weather for Dubai
        getWeatherFor("Dubai")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeatherFor(_ city : String) {
        let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
        let openWeatherMapAPIKey = "c39783593dc21aa3f257cfea6d165f9c"
        
        //create a shared URL session that the send the HTTP request for
        let session = URLSession.shared
        
        //creat the URL which we need to pass to the data task
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
    
        
        //set the data task to download the JSON
        _ = session.dataTask(with: weatherRequestURL) {
            (data, response, error) in
            if error != nil {
                self.lblCurrentTemp.text = "error!"
                self.lblMaxTemp.text = "error!"
                self.lblMinTemp.text = "error!"
            }
            else {
                do{
                    //convert the data to JSON - deserialize the data object
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    print(json)
                    
                    if let dictionary = json as? [String: Any] {
                        
                        let name = dictionary["name"] as? String
                        // access individual value in dictionary
                        print("name = \(name)")
                        
                        if let mainDictionary = dictionary["main"] as? [String: Any] {
                            // access nested dictionary values by key
                            //get the current temperature
                            let current_temp = mainDictionary["temp"] as? Double
                            print("current temp \(current_temp)")
                            
                            let current = current_temp! - 273.15
                            
                            //get the max temperature
                            let max_temp = mainDictionary["temp_max"] as? Double
                            //convert to Celcius
                            let max = (max_temp! - 273.15)
                            print(max)
                            //format to string with with one decimal place
                            let strMax = String.init(format: "%.1f", max)
                            
                            //get the min temperature
                            let min_temp = mainDictionary["temp_min"] as? Double
                            //convert to celcius
                            let min = min_temp! - 273.15
                            print(min)
                            
                            //format to string with with one decimal place
                            let strMin = String.init(format: "%.1f", min)
                            
                            DispatchQueue.main.async(execute: {
                                self.lblCurrentTemp.text = "\(current) c"
                                self.lblMaxTemp.text = "\(strMax) c"
                                self.lblMinTemp.text = "\(strMin) c"
    
                            })
                        }
                    }
                }catch {
                    print("Error with Json: \(error)")
                }
            }
    
        }.resume()
    }


}

