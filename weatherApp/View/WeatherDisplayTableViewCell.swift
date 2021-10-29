//
//  WeatherDisplayTableViewCell.swift
//  weatherApp
//
//  Created by Jason Yeon on 10/29/21.
//

import UIKit

class WeatherDisplayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgWeather: UIImageView!
    
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblTemp: UILabel!
    
    @IBOutlet weak var lblWeather: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
