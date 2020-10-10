import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String)
    func didUpdateCurrency(currency : String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "14CD40A7-423F-449F-A8CF-CBA90EBF8358"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPreis(for currency : String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        let dataUrl = urlString
        self.delegate?.didUpdateCurrency(currency: currency)
        performRequest(with: dataUrl)
    }
    
    func performRequest(with urlString : String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data , response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let price = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", price)
                        self.delegate?.didUpdatePrice(price: priceString)
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
