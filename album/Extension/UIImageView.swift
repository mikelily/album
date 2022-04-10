//
//  UIImageView.swift
//  album
//
//  Created by 林華淵 on 2022/4/6.
//

import UIKit
import Foundation

extension UIImageView {
    /** 從網路下載圖片給 ImageView 使用 */
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.clipsToBounds = true
                self.layer.cornerRadius = 10
                self.image = image
            }
        }.resume()
    }
    /** 從網路下載圖片給 ImageView 使用 */
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
