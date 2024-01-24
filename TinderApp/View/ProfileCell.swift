//
//  ProfileCell.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 5.01.2024.
//

import UIKit

class ProfileCell: UICollectionViewCell{
    
    //MARK: - Properties
    
    let imageView = UIImageView()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "kelly1")
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
