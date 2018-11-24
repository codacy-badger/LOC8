//
//  ColorsTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 1/4/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import UIKit

public typealias CollectionHandler = (Int) -> Void

open class ColorsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var handler: CollectionHandler?
    
    open func initialize(_ item: Int, handler: @escaping CollectionHandler) {
        self.collectionView.selectItem(at: IndexPath(item: item, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.right)
        self.handler = handler
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TabBarItemColor.Colors.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = TabBarItemColor.Colors[indexPath.item]
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.handler?(indexPath.item)
    }
}
