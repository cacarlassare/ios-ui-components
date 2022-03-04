//
//  WeatherBannerView.swift
//  
//
//  Created by Natu Brasesco on 21/09/2021.
//

import UIKit


// MARK: Weather Info Model

public struct WeatherInfo {
    let iconData: Data?
    let cityName: String
    let description: String
    let humidity: String
    let currentTemp: String
    let maxTemp: String
    let minTemp: String
    
    public init(iconData: Data?, cityName: String, description: String, humidity: String, currentTemp: String, maxTemp: String, minTemp: String) {
        self.iconData = iconData
        self.cityName = cityName
        self.description = description
        self.humidity = humidity
        self.currentTemp = currentTemp
        self.maxTemp = maxTemp
        self.minTemp = minTemp
    }
}


// MARK: Weather Banner View

class WeatherBannerView: UIView {
    
    // MARK: UI Constants
    
    private struct UIConstants {
        static let iconHeightWidth: CGFloat = 100
        static let iconPadding: CGFloat = -10
        static let leadingTrailingPadding: CGFloat = 16
        static let topBottomPadding: CGFloat = 12
    }
    
    
    // MARK: Private props
    
    private var weatherInfo: WeatherInfo!
    
    // Lazy UI Components
    
    lazy private var iconImageView: UIImageView? = {
        let iconView = UIImageView()
        guard let data = weatherInfo.iconData else { return nil }
        
        iconView.image = UIImage(data: data)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        return iconView
    }()
    
    lazy private var cityLabel: UILabel = {
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let cityLabel = createLabel(textColor: .black, font: font)
        cityLabel.text = weatherInfo.cityName
        
        return cityLabel
    }()
    
    lazy private var descriptionLabel: UILabel = {
        let font = UIFont.systemFont(ofSize: 12, weight: .regular)
        let descriptionLabel = createLabel(textColor: .gray, font: font)
        descriptionLabel.text = weatherInfo.description
        
        return descriptionLabel
    }()
    
    lazy private var humidityLabel: UILabel = {
        let font = UIFont.systemFont(ofSize: 12, weight: .regular)
        let humidityLabel = createLabel(textColor: .gray, font: font)
        humidityLabel.text = weatherInfo.humidity
        
        return humidityLabel
    }()
    
    lazy private var tempLabel: UILabel = {
        let font = UIFont.systemFont(ofSize: 43, weight: .light)
        let tempLabel = createLabel(textColor: .black, font: font)
        tempLabel.text = weatherInfo.currentTemp
        
        return tempLabel
    }()
    
    lazy private var minMaxTempLabel: UILabel = {
        let font = UIFont.systemFont(ofSize: 13, weight: .regular)
        let minMaxTempLabel = createLabel(textColor: .black, font: font)
        minMaxTempLabel.text = (weatherInfo.minTemp) + " / " + (weatherInfo.maxTemp)
        
        return minMaxTempLabel
    }()
    
    
    // MARK: Public methods
    
    public func setWeatherInfo(weatherInfo: WeatherInfo) {
        self.weatherInfo = weatherInfo
        self.addItems(iconImage: iconImageView,
                 cityLabel: cityLabel,
                 descriptionLabel: descriptionLabel,
                 humidityLabel: humidityLabel,
                 tempLabel: tempLabel,
                 minMaxTempLabel: minMaxTempLabel)
    }
    
    
    // MARK: Private methods
    
    private func createLabel(textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.sizeToFit()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func addItems(iconImage: UIImageView?,
                          cityLabel: UILabel,
                          descriptionLabel: UILabel,
                          humidityLabel: UILabel,
                          tempLabel: UILabel,
                          minMaxTempLabel: UILabel) {
        
        self.addSubview(cityLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(humidityLabel)
        self.addSubview(tempLabel)
        self.addSubview(minMaxTempLabel)
        
        // Some Constraint will vary if there's no icon to display.
        if let icon = iconImage {
            self.addSubview(icon)
            NSLayoutConstraint.activate([
                icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.iconPadding),
                icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                icon.widthAnchor.constraint(equalToConstant: UIConstants.iconHeightWidth),
                icon.heightAnchor.constraint(equalToConstant: UIConstants.iconHeightWidth),
                cityLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: UIConstants.iconPadding)
            ])
        } else {
            NSLayoutConstraint.activate([
                cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.leadingTrailingPadding)
            ])
        }
        
        // General Constraints.
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.topBottomPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: humidityLabel.topAnchor),
            humidityLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            humidityLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIConstants.topBottomPadding),
            tempLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.leadingTrailingPadding),
            tempLabel.bottomAnchor.constraint(equalTo: minMaxTempLabel.topAnchor, constant: 3),
            minMaxTempLabel.leadingAnchor.constraint(equalTo: tempLabel.leadingAnchor),
            minMaxTempLabel.bottomAnchor.constraint(equalTo: humidityLabel.bottomAnchor)
        ])
    }
}
