//
//  DownloadListViewController.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 25.08.2021.
//

import UIKit

protocol DownloadListViewControllerViewModelType {
    func numberOfRowsInSection() -> Int
    func getViewModelForCell(_ indexPath: IndexPath) -> DownloadLictCellViewModelType?
    func deleteRow(_ index: Int)
    func tapRow(_ index: Int)
}

class DownloadListViewController: UIViewController {
    
    var viewModel: DownloadListViewControllerViewModelType?
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
        setEditButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Download list"
    }
    
    private func configureTableView() {
        tableView?.dataSource = self
        tableView?.delegate = self
        
        let nib = UINib(nibName: "DownloadLictCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: DownloadLictCell.reuseId)
    }
    
    private func setEditButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
    }
    
    @objc private func editButtonPressed() {
        tableView?.setEditing(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed))
    }
    
    @objc private func doneButtonPressed() {
        tableView?.setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
    }
    
}

extension DownloadListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DownloadLictCell.reuseId,
                for: indexPath) as? DownloadLictCell else { return UITableViewCell() }
        
        cell.viewModel = viewModel?.getViewModelForCell(indexPath)
        
        return cell
    }
    
}

extension DownloadListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel?.tapRow(indexPath.row)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _,_,_  in
            self?.viewModel?.deleteRow(indexPath.row)
            self?.tableView?.reloadData()
        }
        let config = UISwipeActionsConfiguration(actions: [delete])
        
        return config
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteRow(indexPath.row)
            tableView.reloadData()
        }
    }
}
