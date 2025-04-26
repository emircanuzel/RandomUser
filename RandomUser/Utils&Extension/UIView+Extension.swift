//
//  UIView+Extension.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit
import Collections

extension UIView {
    func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    func addShadow(
        color: UIColor = .black,
        opacity: Float = 0.1,
        offset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 4
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}

extension Array where Element: Hashable {
    public func unique() -> Self {
        let orderedSet = OrderedSet(self)
        return Array(orderedSet)
    }
}

extension UIImageView {
    private static let imageCache = NSCache<NSString, UIImage>()
    
    func setImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
        downloadImage(from: url)
    }
    
    private func downloadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}

extension UIViewController {
    func removeBackButtonTitle() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
    }
}

extension String {
    func toReadableDate() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = formatter.date(from: self) {
            let readableFormatter = DateFormatter()
            readableFormatter.dateStyle = .medium
            readableFormatter.timeStyle = .medium
            
            return readableFormatter.string(from: date)
        }
        
        return nil
    }
}
