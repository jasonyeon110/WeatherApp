//
//  CurrentWeather.swift
//  weatherApp
//
//  Created by Jason Yeon on 10/28/21.
//

import Foundation
import RealmSwift


class CurrentWeather {
    var cityKey : String = ""
    var cityInfoName : String = ""
    var weatherText : String = ""
    var epochTime : Int = Int.min
    var isDayTime : Bool = true
    var temp : Int = Int.min
    var weatherIcon: Int = Int.min
}
