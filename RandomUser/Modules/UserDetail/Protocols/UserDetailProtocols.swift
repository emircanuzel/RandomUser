//
//  UserDetailProtocols.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

// MARK: - UserDetailView

protocol UserDetailView{
    var collectionView: UICollectionView { get }
}

// MARK: - UserDetailViewPresentation

protocol UserDetailViewPresentation: AnyObject {
    var view: UserDetailView? { get set }

    func viewDidLoad()
}
