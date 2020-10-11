import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

//MARK: - CoinManagerDelegate

extension ViewController : CoinManagerDelegate {
    func didUpdatePriceAndCurrency(price: String, currency: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.bitcoinLabel.text = price
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerView DataSource & Delegate

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Shows columns number
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Shows rows number
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    //Shows rows' data
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    //Gives row's index that is choosen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPreis(for: selectedCurrency)
    }
}




