//
//  ViewController.swift
//  Stormy
//
//  Created by Pasan Premaratne on 4/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

extension CurrentWeather {
    var temperatureString: String {
        return "\(Int(temperature))º"
    }
    
    var humidityString: String {
        let percentageValue = Int(humidity * 100)
        return "\(percentageValue)%"
    }
    
    var precipitationProbabilityString: String {
        let percentageValue = Int(precipitationProbability * 100)
        return "\(percentageValue)%"
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var forecastAPIClient = ForecastAPIClient(APIKey: "YOUR_API_KEY")
    let coordinate = Coordinate(latitude: 37.8267, longitude: -122.423)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchCurrentWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchCurrentWeather() {
        forecastAPIClient.fetchCurrentWeather(coordinate) { result in
            self.toggleRefreshAnimation(false)
            switch result {
            case .Success(let currentWeather):
                self.display(currentWeather)
            case .Failure(let error as NSError):
                self.showAlert("Unable to retrieve forecast", message: error.localizedDescription)
            default:
                break
            }
        }

    }
    
    func display(weather: CurrentWeather) {
        currentTemperatureLabel.text = weather.temperatureString
        currentPrecipitationLabel.text = weather.precipitationProbabilityString
        currentHumidityLabel.text = weather.humidityString
        currentSummaryLabel.text = weather.summary
        currentWeatherIcon.image = weather.icon
    }

    func showAlert(title: String, message: String?, style: UIAlertControllerStyle = .Alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(dismissAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func refreshWeather(sender: AnyObject) {
        toggleRefreshAnimation(true)
        fetchCurrentWeather()
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton.hidden = on
        if on {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
    }
}

