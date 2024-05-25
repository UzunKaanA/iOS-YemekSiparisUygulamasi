//
//  SepetViewController.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 21.05.2024.
//

import Kingfisher
import UIKit

class SepetViewController: UIViewController {
    
    @IBOutlet weak var sepetTableView: UITableView!
    @IBOutlet weak var lblToplamFiyat: UILabel!
    var sepetYemeklerListesi = [SepetYemekler]()
    var viewModel = SepetViewModel()
    let kullanici_adi = "Kaan_Uzun"
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "No items in your cart"
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sepetTableView.delegate = self
        sepetTableView.dataSource = self
        
        lblToplamFiyat.text = "0" // Set initial text to "0"
        _ = viewModel.sepetYemeklerListesi.subscribe(onNext: { liste in
            self.sepetYemeklerListesi = liste
            DispatchQueue.main.async {
                self.sepetTableView.reloadData()
                self.calculateTotalPrice() // Call to update the total price
                self.handleEmptyState() // Call this initially to set up UI based on data
            }
        })
        
        setupPlaceholderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.sepetYukle(kullanici_adi: kullanici_adi)
        //Bu sayfa dönüldüğünde veriler yüklenmiş olucak.
    }
    
    
    @IBAction func btnSiparisiTamamla(_ sender: Any) {
        
    }
    
    func calculateTotalPrice() {
        let total = sepetYemeklerListesi.reduce(0) { sum, yemek in
            return sum + (Int(yemek.yemek_fiyat) ?? 0) * (Int(yemek.yemek_siparis_adet) ?? 0)
        }
        lblToplamFiyat.text = "\(total) ₺"
    }
    
    func setupPlaceholderView() {
        view.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func handleEmptyState() {
        updateUIForEmptyState()
        sepetTableView.reloadData() // Reload table view to reflect changes
    }
    
    func updateUIForEmptyState() {
        if sepetYemeklerListesi.isEmpty {
            // Show placeholder view and hide table view
            placeholderLabel.isHidden = false
            sepetTableView.isHidden = true
        } else {
            // Hide placeholder view and show table view
            placeholderLabel.isHidden = true
            sepetTableView.isHidden = false
        }
    }
}


extension SepetViewController: UITableViewDelegate, UITableViewDataSource, SepetCellProtocol {
    func sepettenSilTik(indexPath: IndexPath) {
        let sepetYemek = sepetYemeklerListesi[indexPath.row]
        viewModel.sepettenSil(sepet_yemek_id: Int(sepetYemek.sepet_yemek_id)!, kullanici_adi: kullanici_adi)
        self.sepetYemeklerListesi.remove(at: indexPath.row)
        self.sepetTableView.deleteRows(at: [indexPath], with: .automatic)
        self.calculateTotalPrice()
        handleEmptyState() // Update UI after deleting the item
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetYemeklerListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hucre = tableView.dequeueReusableCell(withIdentifier: "sepetHucre") as! SepetHucre
        
        let yemek = sepetYemeklerListesi[indexPath.row]
        
        hucre.lblYemekAd.text = yemek.yemek_adi
        hucre.lblYemekFiyat.text = "Fiyat: \(yemek.yemek_fiyat) ₺"
        hucre.lblYemekAdet.text = "Adet: \(yemek.yemek_siparis_adet)"
        // Calculate total price for this item
        if let fiyat = Int(yemek.yemek_fiyat), let adet = Int(yemek.yemek_siparis_adet) {
            let toplamFiyat = fiyat * adet
            hucre.lblYemekFiyatToplam.text = "\(toplamFiyat) ₺"
        } else {
            hucre.lblYemekFiyatToplam.text = "0 ₺"
        }
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
                hucre.imageViewSepetYemek.kf.setImage(with: url)
            }
        }
        
        hucre.cellProtocol = self
        hucre.indexPath = indexPath
        
        return hucre
    }
    
}
