//
//  HomeNavigationStackView.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 1.01.2024.
//

import UIKit

protocol BottomControlsStackViewDelegate: AnyObject{
    func handleLike()
    func handleDisLike()
    func handleRefresh()
}

class BottomControlsStackView: UIStackView{
    
    //MARK: - Properties
    
    weak var delegate: BottomControlsStackViewDelegate?
    
    let refreshButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let superlikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        
        refreshButton.setImage(UIImage(named: "refresh_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(UIImage(named: "dismiss_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        superlikeButton.setImage(UIImage(named: "super_like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(UIImage(named: "like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        boostButton.setImage(UIImage(named: "boost_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)

        refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handleDisLike), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)

        [refreshButton, dislikeButton, superlikeButton, likeButton, boostButton].forEach { view in
            addArrangedSubview(view)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh(){
        delegate?.handleRefresh()
    }
    
    @objc func handleDisLike(){
        delegate?.handleDisLike()
    }
    
    @objc func handleLike(){
        delegate?.handleLike()
    }
}
