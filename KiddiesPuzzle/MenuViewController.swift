//
//  MenuViewController.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 27/12/2022.
//

import UIKit

class MenuViewController: UIViewController {

    let data = ["simple", "leaf", "crown", "runner", "star", "tree"]
    
    var menuTableView: UITableView = {
       let view = UITableView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        menuTableView.rowHeight = 100
        
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuTableView)
        NSLayoutConstraint.activate([
            menuTableView.topAnchor.constraint(equalTo: view.topAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        menuTableView.tableFooterView = UIView()
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = data[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        cell?.textLabel?.textAlignment = .center
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let puzzleTitle = data[indexPath.row]
        let puzzleViewController = PuzzlerViewController(dataloader: DataLoader(filename: puzzleTitle))
        puzzleViewController.modalPresentationStyle = .fullScreen
        self.present(puzzleViewController, animated: true)
    }
}
