//
//  ViewController.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 20.05.2024.
//

import UIKit
import Kingfisher

class AnasayfaViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var yemeklerTableView: UITableView!
    var yemeklerListesi = [Yemekler]()
    var viewModel = AnasayfaViewModel()
    let kullanici_adi = "Kaan_Uzun"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        yemeklerTableView.delegate = self
        yemeklerTableView.dataSource = self
        
        _ = viewModel.yemeklerListesi.subscribe(onNext: { liste in
            self.yemeklerListesi = liste
            DispatchQueue.main.async {
                self.yemeklerTableView.reloadData()
            }
        })
    }
    
    @IBAction func btnFiltreler(_ sender: Any) {
        let alertController = UIAlertController(title: "Sort Options", message: "Choose an option to sort the list", preferredStyle: .actionSheet)
                
                let sortByNameAToZ = UIAlertAction(title: "Sort by Name A to Z", style: .default) { _ in
                    self.sortYemekler(by: .nameAToZ)
                }
                let sortByNameZToA = UIAlertAction(title: "Sort by Name Z to A", style: .default) { _ in
                    self.sortYemekler(by: .nameZToA)
                }
                let sortByPriceHighToLow = UIAlertAction(title: "Sort by Price High to Low", style: .default) { _ in
                    self.sortYemekler(by: .priceHighToLow)
                }
                let sortByPriceLowToHigh = UIAlertAction(title: "Sort by Price Low to High", style: .default) { _ in
                    self.sortYemekler(by: .priceLowToHigh)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(sortByNameAToZ)
                alertController.addAction(sortByNameZToA)
                alertController.addAction(sortByPriceHighToLow)
                alertController.addAction(sortByPriceLowToHigh)
                alertController.addAction(cancelAction)
          
                self.present(alertController, animated: true, completion: nil)
    }
    
    enum SortCriteria {
            case nameAToZ
            case nameZToA
            case priceHighToLow
            case priceLowToHigh
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.yemekleriYukle()
        //Bu sayfa dönüldüğünde veriler yüklenmiş olucak.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toYemekDetay" {
            if let yemek = sender as? Yemekler {
                let destinationVC = segue.destination as! YemekDetayViewController
                destinationVC.yemek = yemek
                
                // Construct the cleaned yemek_adi to form the URL
                let cleanedYemekAdi = yemek.yemek_adi
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "ü", with: "u")
                    .replacingOccurrences(of: "ö", with: "o")
                    .replacingOccurrences(of: "ı", with: "i")
                    .replacingOccurrences(of: "ş", with: "s")
                    .replacingOccurrences(of: "ç", with: "c")
                    .replacingOccurrences(of: "ğ", with: "g")
                    .lowercased()
                
                let imageUrlString = "http://kasimadalan.pe.hu/yemekler/resimler/\(cleanedYemekAdi).png"
                destinationVC.imageUrlString = imageUrlString
            }
        }
    }
    
    func sortYemekler(by criteria: SortCriteria) {
        switch criteria {
        case .nameAToZ:
            yemeklerListesi.sort { $0.yemek_adi.lowercased() < $1.yemek_adi.lowercased() }
        case .nameZToA:
            yemeklerListesi.sort { $0.yemek_adi.lowercased() > $1.yemek_adi.lowercased() }
        case .priceHighToLow:
            yemeklerListesi.sort { Int($0.yemek_fiyat)! > Int($1.yemek_fiyat)! }
        case .priceLowToHigh:
            yemeklerListesi.sort { Int($0.yemek_fiyat)! < Int($1.yemek_fiyat)! }
        }
        
        DispatchQueue.main.async {
            self.yemeklerTableView.reloadData()
        }
    }

}

extension AnasayfaViewController : UISearchBarDelegate  {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.ara(aramaKelimesi: searchText)  // Call the search method in the view model
    }
}


extension AnasayfaViewController : UITableViewDelegate, UITableViewDataSource, YemeklerCellProtocol {
    func sepeteEkleTik(indexPath: IndexPath) {
        let yemek = yemeklerListesi[indexPath.row]
        print("Anasayfa: \(yemek.yemek_adi) + \(yemek.yemek_fiyat) ₺ sepete eklendi")
        viewModel.sepetEkleVeyaGuncelle(
            yemek_adi: yemek.yemek_adi,
            yemek_resim_adi: yemek.yemek_resim_adi,
            yemek_fiyat: Int(yemek.yemek_fiyat)!,
            yemek_siparis_adet: 1,
            kullanici_adi: kullanici_adi
        )
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yemeklerListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hucre = tableView.dequeueReusableCell(withIdentifier: "yemeklerHucre") as! YemeklerHucre
        
        let yemek = yemeklerListesi[indexPath.row]
        
        hucre.lblAd.text = yemek.yemek_adi
        hucre.lblFiyat.text = "\(yemek.yemek_fiyat) ₺"
        // Clean up yemek_adi to remove spaces and convert to lowercase
        let cleanedYemekAdi = yemek.yemek_adi
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "ü", with: "u")
            .replacingOccurrences(of: "ö", with: "o")
            .replacingOccurrences(of: "ı", with: "i")
            .replacingOccurrences(of: "ş", with: "s")
            .replacingOccurrences(of: "ç", with: "c")
            .replacingOccurrences(of: "ğ", with: "g")
            .lowercased()
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(cleanedYemekAdi).png") {
            DispatchQueue.main.async {
                hucre.imageViewYemek.kf.setImage(with: url)
            }
        }
        
        hucre.cellProtocol =  self
        hucre.indexPath = indexPath
        
        return hucre
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let yemek = yemeklerListesi[indexPath.row]
        performSegue(withIdentifier: "toYemekDetay", sender: yemek)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

