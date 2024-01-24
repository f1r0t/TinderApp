//
//  File.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 1.01.2024.
//

import UIKit
import Firebase

class HomeController: UIViewController{
    
    //MARK: - Properties
    
    private var user: User?
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private var viewModels = [CardViewModel](){
        didSet{configureCards()}
    }
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 10
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsloggedIn()
        configureUI()
        fetchCurrentUserAndCards()
    
        //logOut()
    }
    
    //MARK: - API
        
    func fetchUsers(forCurrentUser user: User){
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map({CardViewModel(user: $0)})
            
       //Yukarıdaki kod aşağıdaki gibi de yazılabilir.
//            users.forEach { user in
//                let viewModel = CardViewModel(user: user)
//                self.viewModels.append(viewModel)
//            }
        }
    }
    
    func fetchCurrentUserAndCards(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        Service.fetchUser(uid: uid) { user in
            self.user = user
            self.fetchUsers(forCurrentUser: user)
        }
    }
    
    func checkIfUserIsloggedIn(){
        if Auth.auth().currentUser == nil{
            presentLoginController()
        }else{
            print("user")
        }
    }
    
    func logOut(){
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("wdsfds")
        }
    }
    
    func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool){
        Service.saveSwipe(forUser: user, isLike: didLike) { error in
            self.topCardView = self.cardViews.last
            
            guard didLike == true else{return}
            
            Service.checkIfMatchExists(forUser: user) { didMatch in
                self.presentMatchView(forUser: user)
                
                guard let currentUser = self.user else{return}
                Service.uploadMatch(currentUser: currentUser, matchedUser: user)
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureCards(){
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
            //cardViews.append(cardView)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.map({($0 as? CardView)!})
        topCardView = cardViews.last
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        topStack.delegate = self
        bottomStack.delegate = self
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
    }
    
    func presentLoginController(){
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
        }
    }
    
    func presentMatchView(forUser user: User){
        guard let currentUser = self.user else{return}
        
        let viewModel = MatchViewViewModel(currentUser: currentUser, matchedUser: user)
        let matchView = TinderApp.MatchView(viewModel: viewModel)
        matchView.delegate = self
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    func performSwipeAnimation(shouldLike: Bool){
        let translation : CGFloat = shouldLike ? 700 : -700
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.topCardView?.frame = CGRect(x: translation, y: 0, width: self.topCardView?.frame.width ?? 0, height: self.topCardView?.frame.height ?? 0)
        } completion: { _ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else{return}
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
    }
    
}

//MARK: - HomeNavigationStackViewDelegate

extension HomeController: HomeNavigationStackViewDelegate{
    func showSettings() {
        guard let user = self.user else{return}
        let controller = SettingsController(user: user)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showMessages() {
        guard let user = user else{return}
        let controller = MessagesController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

//MARK: - SettingsControllerDelegate

extension HomeController: SettingsControllerDelegate{
    func settingsControllerWantsToLogout(_ controller: SettingsController) {
        dismiss(animated: true, completion: nil)
        logOut()
    }
    
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
    }
}

//MARK: - CardViewDelegate

extension HomeController: CardViewDelegate{
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview()
        self.cardViews.removeAll(where: {view == $0})
        
        guard let user = topCardView?.viewModel.user else{return}
        saveSwipeAndCheckForMatch(forUser: user, didLike: didLikeUser)
        
        self.topCardView = cardViews.last
    }
    
    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        let controller = ProfileController(user: user)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}

//MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate{
    func handleLike() {
        guard let topCard = topCardView else{return}
        
        performSwipeAnimation(shouldLike: true)
        saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
    }
    
    func handleDisLike() {
        guard let topCard = topCardView else{return}
        performSwipeAnimation(shouldLike: false)
        
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: false, completion: nil)
    }
    
    func handleRefresh() {
        guard let user = self.user else{return}
        
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map({CardViewModel(user: $0)})
        }
    }
    
}

//MARK: - ProfileControllerDelegate

extension HomeController: ProfileControllerDelegate{
    func profileController(_ controller: ProfileController, didLikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: true)
            self.saveSwipeAndCheckForMatch(forUser: user, didLike: true)
        }
    }
    
    func profileController(_ controller: ProfileController, didDislikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: false)
            Service.saveSwipe(forUser: user, isLike: false, completion: nil)
        }
    }
    
}

//MARK: - AuthenticationDelegate

extension HomeController: AuthenticationDelegate{
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        fetchCurrentUserAndCards()
    }
}

//MARK: - MatchViewDelegate

extension HomeController: MatchViewDelegate{
    func MatchView(_ view: MatchView, wantsToSendMessageTo user: User) {
        print("\(user.name)")
    }
}
