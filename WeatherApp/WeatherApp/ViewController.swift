//
//  ViewController.swift
//  WeatherApp
//
//  Created by Илья Москалев on 24.05.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherIconImageView: UIImageView!
    
    
    // Инициализируем для получения местоположения
    let locationManager = CLLocationManager()
    
    var weatherData = WeatherData()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startLocationManager()
    }
    
    // Метод для получения местоположения
    func startLocationManager() {
        // Запрос на авторизацию
        locationManager.requestWhenInUseAuthorization()
        
        // Проверка включена ли геолокация
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            // Точность получения координат
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            // Частота обновления
            locationManager.pausesLocationUpdatesAutomatically = false
            // Запуск слежения за местоположением
            locationManager.startUpdatingLocation()
        }
    }

    // Отправляем JSON запрос для получения погоды
    func updateWeatherInfo(latitude: Double, longitude: Double) {
        let session = URLSession.shared
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longitude.description)&units=metric&lang=ru&appid=4b38f7dbee34fb05cb5231c838f889d6")!
        let task = session.dataTask(with: url) { (data, response, error) in
            // Проверка на наличие ошибок
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
                return
            }
            // Блок для получения JSON data
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                // Обновляем view с новыми данными
                DispatchQueue.main.async {
                    self.updateView()
                }
                print(self.weatherData)
            } catch {
                print(error.localizedDescription)
            }
        }
        // После complition handler запускаем для получения данных с сайта
        task.resume()
    }
    
    func updateView() {
        cityNameLabel.text = weatherData.name
        weatherDescriptionLabel.text = DataSource.weatherIDs[weatherData.weather[0].id]
        temperatureLabel.text = weatherData.main.temp.description + "°"
        weatherIconImageView.image = UIImage(named: weatherData.weather[0].icon)
    }
}

    

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Получаем координаты
        if let lastLocation = locations.last {
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
        }
    }
}

