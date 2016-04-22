//
//  ColorsTableViewCell.swift
//  LOC8
//
//  Created by Marwan Al Masri on 1/4/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import UIKit

public typealias CollectionHandler = (Int) -> Void

public class ColorsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var handler: CollectionHandler?
    
    public func initialize(item: Int, handler: CollectionHandler) {
        self.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: item, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Right)
        self.handler = handler
    }
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TabBarItemColor.Colors.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = TabBarItemColor.Colors[indexPath.item]
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.handler?(indexPath.item)
    }
}
