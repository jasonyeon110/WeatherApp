//
//  ViewController.swift
//  weatherApp
//
//  Created by Jason Yeon on 10/28/21.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let arr = ["a", "b", "c"]
    var arrCityInfo: [CityInfo] = [CityInfo]()
    var arrCurrentWeather: [CurrentWeather] = [CurrentWeather]()
    
    @IBOutlet weak var tblView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCurrentConditions()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCurrentWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("WeatherDisplayTableViewCell", owner: self, options: nil)?.first as! WeatherDisplayTableViewCell
        
        let cell = Bundle.main.loadNibNamed("WeatherTableViewCell", owner: self, options: nil)?.first as! WeatherTableViewCell

        let thisCity = arrCurrentWeather[indexPath.row]
        
        cell.lblCity.text = "\(thisCity.cityInfoName)"
        cell.lblTemp.text = "\(thisCity.temp) F"
        cell.lblWeather.text = "\(thisCity.weatherText)"
        cell.imgWeather.image = UIImage(named: "\(thisCity.weatherIcon)")
        
        return cell
    }
    
    func loadCurrentConditions(){
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do{
            let realm = try Realm()
            let cities = realm.objects(CityInfo.self)
            print("these are cities = \(cities)")
            self.arrCityInfo.removeAll()
            
            if(cities.isEmpty){
                return
            }
            getAllCurrentWeather(Array(cities)) .done { currentWeather in
//                print(currentWeather)
                self.arrCurrentWeather.append(contentsOf: currentWeather)
                self.tblView.reloadData()
            }
            .catch{ error in
                print(error)
            }
        }catch{
            print("error in reading database \(error)")
        }
        
    }
    
    //1:29:39
    func getAllCurrentWeather(_ cities: [CityInfo] ) -> Promise<[CurrentWeather]> {
        var promises: [Promise<CurrentWeather>] = []
        
        for i in 0 ... cities.count - 1{
            promises.append(getCurrentWeather(cities[i].key))
        }
        return when(fulfilled: promises)
    }
    
    //1:27:08
    func getCurrentWeather(_ cityKey : String) -> Promise<CurrentWeather>{
            return Promise<CurrentWeather> { seal -> Void in
                let url = currentConditionURL + "\(cityKey)" + "?apikey=" + apikey
                
                AF.request(url).responseJSON { response in
                    if response.error != nil {
                        seal.reject(response.error!)
                    }
    
//                    print(JSON(response.data!).array)
                    let weather = JSON(response.data!).array
                    
                    guard let firstWeather = weather!.first else {
                        return
                    }
                    
                    let currentWeather = CurrentWeather()
                    
                    currentWeather.cityKey = cityKey
                    currentWeather.cityInfoName = self.loadCityName(cityKey)
                    currentWeather.weatherText = firstWeather["WeatherText"].stringValue
                    currentWeather.epochTime = firstWeather["EpochTime"].intValue
                    currentWeather.isDayTime = firstWeather["IsDayTime"].boolValue
                    currentWeather.temp = firstWeather["Temperature"]["Imperial"]["Value"].intValue
                    currentWeather.weatherIcon = firstWeather["WeatherIcon"].intValue
                    print(currentWeather.cityInfoName)
                    seal.fulfill(currentWeather)
                    
                }
            }
        }
    
    func loadCityName(_ cityKey: String) -> String {
        do{
            let realm = try Realm()
            let cityName = realm.object(ofType: CityInfo.self, forPrimaryKey: cityKey)
            return cityName!.localizedName
        } catch {
            print("Error in getting values from Database \(error)")
        }
        return ""
    }
    
}

