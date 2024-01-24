//
//  MessagesController.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 8.01.2024.
//

import UIKit

private let reuseIdentifier = "Cell"

class MessagesController: UITableViewController{
    
    //MARK: - Properties
    
    private let user: User
    
    private let headerView = MatchHeader()
    
    //MARK: - Lifecycle

    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
        fetchMatches()
    }
    
    //MARK: - Actions
    
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - API
    
    func fetchMatches(){
        Service.fetchMatches { matches in
            self.headerView.matches = matches
        }
    }
    //MARK: - Helpers
    
    func configureTableView(){
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        headerView.delegate = self
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        tableView.tableHeaderView = headerView
    }
    
    func configureNavigationBar(){
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 28, width: 28)
        leftButton.isUserInteractionEnabled = true
        leftButton.image = UIImage(named: "app_icon")?.withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        leftButton.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let icon = UIImageView(image: UIImage(named: "top_messages_icon")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = .systemPink
        navigationItem.titleView = icon
    }
}

//MARK: - UITableViewDataSource

extension MessagesController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MessagesController{
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        
        label.text = "Messages"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        return view
    }
}

//MARK: - MatchHeaderDelegate

extension MessagesController: MatchHeaderDelegate{
    func matchHeader(_ header: MatchHeader, wantsToChatWith uid: String) {
        Service.fetchUser(uid: uid) { user in
            print("fdsfsf")
        }
    }
    
    
}
