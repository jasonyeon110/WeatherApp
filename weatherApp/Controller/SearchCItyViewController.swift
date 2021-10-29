//
//  SearchCItyViewController.swift
//  weatherApp
//
//  Created by Jason Yeon on 10/28/21.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire
import PromiseKit
import RealmSwift


class SearchCItyViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var arr = ["Seattle", "What", "The", "Heck?"]
    
    var arrCityInfo: [CityInfo]! = [CityInfo]()

    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrCityInfo.removeAll()
        if searchText.count < 3 {
            return
        }
        getCitiesFromSearch(searchText)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCityInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let city = arrCityInfo[indexPath.row].value(forKey: "localizedName") as! String
        let state = arrCityInfo[indexPath.row].value(forKey: "administrativeID") as! String
        let country = arrCityInfo[indexPath.row].value(forKey: "countryLocalizedName") as! String
        
        let cityData = "\(city), \(state), \(country)"
        
        cell.textLabel?.text = cityData
        
        return cell
    }
    
    func getSearchURL(_ searchText: String) -> String{
        return locationSearchURL + "apikey=" + apikey + "&q=" + searchText
    }

    //56:54
    func getCitiesFromSearch(_ searchText: String) {
            let url = getSearchURL(searchText)
            
            AF.request(url).responseJSON { response in
                if response.error != nil {
                    print(response.error?.localizedDescription)
                }
                
                let cities = JSON(response.data!).array
                
                for city in cities! {
                    let cityInfo = CityInfo()
                    cityInfo.key = city["Key"].stringValue
                    cityInfo.type = city["Type"].stringValue
                    cityInfo.localizedName = city["LocalizedName"].stringValue
                    cityInfo.countryLocalizedName = city["Country"]["LocalizedName"].stringValue
                    cityInfo.administrativeID = city["AdministrativeArea"]["ID"].stringValue
                    
                    self.arrCityInfo.append(cityInfo)
//                    print(self.arrCityInfo!)
                }
            self.tblView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityIndex = arrCityInfo[indexPath.row]
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(cityIndex, update: .modified)
            }
        } catch {
            print("error in saving the city \(error)")
        }
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

}
    
