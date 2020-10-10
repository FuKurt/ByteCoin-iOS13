//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "14CD40A7-423F-449F-A8CF-CBA90EBF8358"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPreis(for currency : String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        let dataUrl = urlString
        performRequest(with: dataUrl)
    }
    
    func performRequest(with urlString : String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data , response, error) in
                if error != nil{
                    print("something is wrong")
                    return
                }
                if let safeData = data {
                    if let price = self.parseJSON(safeData) {
                        print(price)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data : Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
        } catch {
            print(error)
            return nil
        }
    }
}
