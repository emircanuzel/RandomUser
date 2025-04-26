//
//  CollectionView+Extension.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

extension UICollectionReusableView: ReusableView { }

extension UICollectionView {
    public func registerClass<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("🚨 Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

public protocol ReusableView: AnyObject { }

extension ReusableView where Self: UIView {
    public static var reuseIdentifier: String {
        String(describing: self)
    }

    public func prepareForReuse() { }
}
