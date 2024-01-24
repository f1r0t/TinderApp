//
//  ProfileController.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 5.01.2024.
//

import UIKit

private let reuseIdentifier = "ProfileCell"

protocol ProfileControllerDelegate: AnyObject{
    func profileController(_ controller: ProfileController, didLikeUser user: User)
    func profileController(_ controller: ProfileController, didDislikeUser user: User)
}

class ProfileController: UIViewController{
    
    //MARK: - Properties
    
    private let user: User
    
    weak var delegate: ProfileControllerDelegate?
    
    private lazy var viewModel = ProfileViewModel(user: user)
    private lazy var barStackView = SegmentedBarView(numberOfSegments: viewModel.imageURLs.count)
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .black
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "dismiss_down_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let professionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Actress"
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "I was in Transformers"
        return label
    }()
    
    private lazy var disLikeButton: UIButton = {
        let button = createButton(withImage: UIImage(named: "dismiss_circle")!)
        button.addTarget(self, action: #selector(handleDisLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var superLikeButton: UIButton = {
        let button = createButton(withImage: UIImage(named: "super_like_circle")!)
        button.addTarget(self, action: #selector(handleSuperLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImage: UIImage(named: "like_circle")!)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadUserData()
    }
    
    //MARK: - Actions
    
    @objc func handleDisLike(){
        delegate?.profileController(self, didDislikeUser: user)
    }
    
    @objc func handleSuperLike(){
        
    }
    
    @objc func handleLike(){
        delegate?.profileController(self, didLikeUser: user)
    }
    
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func loadUserData(){
        
        infoLabel.attributedText = viewModel.userDetailsAttributedString
        professionLabel.text = viewModel.profession
        bioLabel.text = viewModel.bio
    }
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        view.addSubview(dismissButton)
        dismissButton.setDimensions(height: 40, width: 40)
        dismissButton.anchor(top: collectionView.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingRight: 16)
        
        let infoStack = UIStackView(arrangedSubviews: [infoLabel, professionLabel, bioLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
       
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor)
        
        configureBottomControls()
        configureBarStackView()
    }
    
    func configureBarStackView(){

        view.addSubview(barStackView)
        barStackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 8, paddingRight: 8, height: 4)
    }
    
    func configureBottomControls(){
        let stack = UIStackView(arrangedSubviews: [disLikeButton, superLikeButton, likeButton])
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.spacing = -32
        stack.setDimensions(height: 80, width: 300)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
    }
    
    func createButton(withImage image: UIImage)->UIButton{
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
}

//MARK: - UICollectionViewDataSource

extension ProfileController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        cell.imageView.sd_setImage(with: viewModel.imageURLs[indexPath.row])
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProfileController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView.setHighlighted(index: indexPath.row)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
