//
//  SepetHucre.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 24.05.2024.
//

import UIKit

protocol SepetCellProtocol : AnyObject{
    func sepettenSilTik(indexPath: IndexPath)
}

class SepetHucre: UITableViewCell {
    
    @IBOutlet weak var lblYemekAd: UILabel!
    @IBOutlet weak var lblYemekFiyatToplam: UILabel!
    @IBOutlet weak var lblYemekAdet: UILabel!
    @IBOutlet weak var lblYemekFiyat: UILabel!
    @IBOutlet weak var imageViewSepetYemek: UIImageView!
    
    weak var cellProtocol: SepetCellProtocol?
    var indexPath: IndexPath?
    
    @IBAction func btnSil(_ sender: Any) {
        //        if let indexPath = indexPath {
        //            cellProtocol?.sepettenSilTik(indexPath: indexPath)
        //}
        guard let indexPath = indexPath else { return }
        showAlertForDelete(indexPath: indexPath)
        
    }
    
    private func showAlertForDelete(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.cellProtocol?.sepettenSilTik(indexPath: indexPath)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
